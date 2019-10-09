## Half-precision neural nets in PyTorch

I would like to draw your attention to running PyTorch in half-precision (16-bit float).
Our GPUs (V100) have "tensor cores" which make float16 operations nearly 2 times faster than the usual float32. The memory needed is reduced 2 times as well.

### Apex library - simple float16 for PyTorch
There are some tricks involved in running neural nets on float16 (loss scaling, batch norm precision etc). Conveniently, they have been implemented in the [apex library](https://github.com/NVIDIA/apex).  
With it, we can run NNs in float16 with minimal code changes: we only wrap the NN and optimizer, and change the backward step invocation.  
[[apex wrapping documentation]](https://nvidia.github.io/apex/amp.html#opt-levels-and-properties)

```python
import apex.amp
# wrap the network module and its optimizer
network, optimizer = apex.amp.initialize(network, optimizer, opt_level="O1")
...
# loss.backward() becomes:
with apex.amp.scale_loss(loss, optimizer) as scaled_loss:
    scaled_loss.backward()
```

### FusedAdam
`apex.optimizers.FusedAdam` [[doc]](https://nvidia.github.io/apex/optimizers.html#apex.optimizers.FusedAdam) is a faster drop-in replacement for `torch.optim.Adam`, it can be used in both float32 and float16.


### Docker image
Apex needs to be built from source, but I have done that and provide it in the following image:

[`ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest`](../images/lab-pytorch-apex/Dockerfile)
