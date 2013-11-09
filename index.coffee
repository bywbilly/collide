{vec3} = require 'math'

module.exports = collision = {}

testInterval = (s1, f1, s2, f2) -> !(s2 > f1 || s1 > f2)

testAABB = (a, b) ->
  return false unless testInterval a.min[0], a.max[0], b.min[0], b.max[0]
  return false unless testInterval a.min[1], a.max[1], b.min[1], b.max[1]
  return false unless testInterval a.min[2], a.max[2], b.min[2], b.max[2]
  return true

temp = vec3.create()
voxel = vec3.create()
dimensions = vec3.fromValues 1, 1, 1
a = min: vec3.create(), max: vec3.create()
b = min: vec3.create(), max: vec3.create()

collision.collide = (out, subject, volume) ->
  
  out ?= temp
  
  vec3.floor voxel, subject.position
  
  vec3.copy a.min, subject.position
  a.min[0] -= 0.25
  a.min[2] -= 0.25
  vec3.copy a.max, subject.position
  a.max[0] += 0.25
  a.max[1] += 1.75
  a.max[2] += 0.25
  
  for i in [voxel[0]-1..voxel[0]+1]
    for j in [voxel[1]-1..voxel[1]+1]
      for k in [voxel[2]-1..voxel[2]+1]
        
        continue unless volume.solid i, j, k
        
        vec3.set b.min, i, j, k
        vec3.add b.max, b.min, dimensions
        
        if testAABB a, b
          vec3.set out, i, j, k
          return true
  
  return false