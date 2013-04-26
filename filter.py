import neurolab as nl
import numpy as np
import sys
import json

if len(sys.argv) != 4:
  print "Usage: " + sys.argv[0] + " ref.json train.json in.json"
  exit(1)

# Read json input
ref = json.loads(open(sys.argv[1]).read())
trn = json.loads(open(sys.argv[2]).read())
inp = json.loads(open(sys.argv[3]).read())

# Make lists of deltas
target = ref['path']
target = [[x[0] - target[i - 1][0], x[1] - target[i - 1][1]] for i, x in enumerate(target)][1:]
train = trn['path']
train = [[x[0] - train[i - 1][0], x[1] - train[i - 1][1]] for i, x in enumerate(train)][1:]
train = train[:len(target)]
input = inp['path']
input = [[x[0] - input[i - 1][0], x[1] - input[i - 1][1]] for i, x in enumerate(input)][1:]
input = input[:len(target)]

# Create network with 2 layers
net = nl.net.newelm([[-8, 8], [-8, 8]], [20, 2], [nl.trans.TanSig(), nl.trans.PureLin()])
# Set initialized functions and init
net.layers[0].initf = nl.init.InitRand([-0.1, 0.1], 'wb')
net.layers[1].initf = nl.init.InitRand([-0.1, 0.1], 'wb')
net.init()
# Train network
error = net.train(train, target, epochs=1000, show=100, goal=0.0001)
# Simulate network
output = net.sim(input)

# Plot result
import pylab as pl
pl.subplot(311)
pl.plot(error)
pl.xlabel('Epoch number')
pl.ylabel('Train error (default MSE)')

range = 200
pl.subplot(312)
pl.plot([x[0] for x in target][:range])
pl.plot([x[0] for x in input][:range])
pl.plot([x[0] for x in output][:range])
pl.legend(['train x', 'input x', 'output x'])

pl.subplot(313)
pl.plot([x[1] for x in target][:range])
pl.plot([x[1] for x in input][:range])
pl.plot([x[1] for x in output][:range])
pl.legend(['train y', 'input x', 'output y'])

pl.show()
pl.savefig('test.png')

# Dump out output JSON
data = [inp['path'][0]]
for x in output:
  last = data[-1]
  data.append([last[0] + x[0], last[1] + x[1]])

outjson = inp
outjson['path'] = data
with open('out.json', 'w') as outfile:
  json.dump(outjson, outfile)
