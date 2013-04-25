import neurolab as nl
import numpy as np
import sys
import json

if len(sys.argv) != 3:
  print "Usage: " + sys.argv[0] + " in.json des.json"
  exit(1)

# Read json input
inp = json.loads(open(sys.argv[1]).read())
des = json.loads(open(sys.argv[2]).read())

# Create train samples
#i1 = np.sin(np.arange(0, 20))
#i2 = np.sin(np.arange(0, 20)) * 2
#
#t1 = np.ones([1, 20])
#t2 = np.ones([1, 20]) * 2
#
#input = np.array([i1, i2, i1, i2]).reshape(20 * 4, 1)
#target = np.array([t1, t2, t1, t2]).reshape(20 * 4, 1)

input = inp['path']
print input
input = [[x[0] - input[i - 1][0], x[1] - input[i - 1][1]] for i, x in enumerate(input)][1:]
print input
target = input

# Create network with 2 layers
net = nl.net.newelm([[-8, 8], [-8, 8]], [10, 2], [nl.trans.TanSig(), nl.trans.PureLin()])
# Set initialized functions and init
net.layers[0].initf = nl.init.InitRand([-0.1, 0.1], 'wb')
net.layers[1].initf = nl.init.InitRand([-0.1, 0.1], 'wb')
net.init()
# Train network
error = net.train(input, target, epochs=5000, show=100, goal=0.0001)
# Simulate network
output = net.sim(input)

# Plot result
import pylab as pl
pl.subplot(211)
pl.plot(error)
pl.xlabel('Epoch number')
pl.ylabel('Train error (default MSE)')

pl.subplot(212)
pl.plot(target)
pl.plot(output)
pl.legend(['train target', 'net output'])
pl.show()
pl.savefig('test.png')
