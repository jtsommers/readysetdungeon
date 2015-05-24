import subprocess
import json
import collections
import random
import sys

def generate_and_solve():
    output = generate();
    design = parse_json_result(output)
    print render_ascii_dungeon(design)

def generate():
    gringo = subprocess.Popen(
        "gringo -c width=7 level-core.lp level-style.lp level-sim.lp level-shortcuts.lp | reify | clingo  --parallel-mode=4 --outf=2 - meta.lp metaD.lp metaO.lp metaS.lp",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True)
    out, err = gringo.communicate()
    if err:
        print err

    return out
    

def solve(*args):
    """Run clingo with the provided argument list and return the parsed JSON result."""
    
    CLINGO = "clingo"
    
    clingo = subprocess.Popen(
        [CLINGO, "--outf=2"] + list(args),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    out, err = clingo.communicate()
    if err:
        print err
        
    return parse_json_result(out)

def parse_json_result(out):
    """Parse the provided JSON text and extract a dict
    representing the predicates described in the first solver result."""

    result = json.loads(out)
    
    assert len(result['Call']) > 0
    assert len(result['Call'][0]['Witnesses']) > 0
    
    witness = result['Call'][0]['Witnesses'][0]['Value']
    
    class identitydefaultdict(collections.defaultdict):
        def __missing__(self, key):
            return key
    
    preds = collections.defaultdict(set)
    env = identitydefaultdict()
    
    for atom in witness:
        if '(' in atom:
            left = atom.index('(')
            functor = atom[:left]
            arg_string = atom[left:]
            try:
                preds[functor].add( eval(arg_string, env) )
            except TypeError:
                pass # at least we tried...
            
        else:
            preds[atom] = True
    
    return dict(preds)

def solve_randomly(*args):
    """Like solve() but uses a random sign heuristic with a random seed."""
    args = list(args) + ["--sign-def=3","--seed="+str(random.randint(0,1<<30))]
    return solve(*args) 

def render_ascii_dungeon(design):
    """Given a dict of predicates, return an ASCII-art depiction of the a dungeon."""
    
    sprite = dict(design['sprite'])
    param = dict(design['param'])
    width = param['width']
    glyph = dict(space='.', wall='W', altar='a', gem='g', trap='_')
    block = ''.join([''.join([glyph[sprite.get((r,c),'space')]+' ' for c in range(width)])+'\n' for r in range(width)])
    return block

def render_ascii_touch(design, target):
    """Given a dict of predicates, return an ASCII-art depiction where the player explored
    while in the `target` state."""
    
    touch = collections.defaultdict(lambda: '-')
    for cell, state in design['touch']:
        if state == target:
            touch[cell] = str(target)
    param = dict(design['param'])
    width = param['width']
    block = ''.join([''.join([str(touch[r,c])+' ' for c in range(width)])+'\n' for r in range(width)])
    return block

def side_by_side(*blocks):
    """Horizontally merge two ASCII-art pictures."""
    
    lines = []
    for tup in zip(*map(lambda b: b.split('\n'), blocks)):
        lines.append(' '.join(tup))
    return '\n'.join(lines)



generate_and_solve()

