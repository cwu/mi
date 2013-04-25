import json
import os
import math

def circle():
    offset = 10
    radius = 50
    upper_circle = [ [x + radius+offset, math.sqrt(radius* radius - x * x) + radius + offset] for x in xrange(-radius, radius+1) ]
    lower_circle = [ [x + radius+offset, -math.sqrt(radius * radius - x * x) + radius+ offset] for x in xrange(radius, -radius-1, -1) ]

    store_path(upper_circle + lower_circle, 'circle')

def store_path(path, name):
    with open(os.path.join('paths', '%s.json' % name), 'w') as f:
        f.write(json.dumps({'name':name,'path':path}))

if __name__ == '__main__':
    circle()
