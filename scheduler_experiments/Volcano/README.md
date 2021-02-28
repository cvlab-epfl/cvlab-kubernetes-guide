

### Resources in the cluster

$ku get nodes
	NAME                             STATUS   ROLES    AGE   VERSION
	iccluster060.iccluster.epfl.ch   Ready    master   52d   v1.19.6
	iccluster062.iccluster.epfl.ch   Ready    <none>   52d   v1.19.6
	iccluster063.iccluster.epfl.ch   Ready    <none>   52d   v1.19.6

$ku describe nodes/iccluster062.iccluster.epfl.ch
	...
	Capacity:
		cpu:                48
		ephemeral-storage:  226715140Ki
		hugepages-1Gi:      0
		hugepages-2Mi:      0
		memory:             264039856Ki
		nvidia.com/gpu:     2
		pods:               110

There are 3 nodes, each with 2 GPUs, 48 cores, and 264G mem.



### Queue spec 

<https://volcano.sh/en/docs/queue/>

```yaml
apiVersion: scheduling.volcano.sh/v1beta1
kind: Queue
metadata:
  name: default

spec:
  reclaimable: true
  weight: 1
#   capability:
#     cpu: "4"
#     memory: "4096Mi"
```

### Job

<https://volcano.sh/en/docs/vcjob/>


```yaml
apiVersion: batch.volcano.sh/v1alpha1
kind: Job
metadata:
  name: jobs-p1
spec:
  schedulerName: volcano
  queue: q-p1
  # minAvailable represents the minimum number of running pods required to run the job. Only when the number of running pods is not less than minAvailable can the job be considered as running.
  #minAvailable: 3 
  #priorityClassName: high-priority
  policies:
    - event: PodEvicted
      action: RestartJob
  maxRetry: 5
  tasks:
    - replicas: 5
      name: task-p1
      restartPolicy: Never
      template:
        metadata:
          name: template-p1
        spec:
          containers:
            - name: worker-p1
              image: "alpine:latest"
              command: ["/bin/sleep", "180"]
                limits:
                  nvidia.com/gpu: 1
                requests:
                  nvidia.com/gpu: 1
```


#### Volcano GPU plugin

There is a guide on Volcano GPU sharing  
<https://github.com/volcano-sh/volcano/blob/master/docs/user-guide/how_to_use_gpu_sharing.md>

It points to a module for working with GPUs. Its existence suggests that by default Volcano is not aware of GPUs.
  
<https://github.com/volcano-sh/devices>

The module offers 2 resources to specify in `limits`: `volcano.sh/gpu-memory`, `volcano.sh/gpu-number`.
The `gpu-number` appears to not be implemented yet:  
<https://github.com/volcano-sh/devices/issues/12>   
<https://github.com/volcano-sh/devices/issues/11>

We could install the module and see how the GPU memory sharing works in practice.

#### Preemption disabled by default

<https://github.com/volcano-sh/volcano/issues/200>


To fix that, we need to apply the config in [volcano-scheduler-ci.conf](https://github.com/volcano-sh/volcano/blob/master/installer/helm/chart/volcano/config/volcano-scheduler-ci.conf)
which does have `actions: "enqueue, reclaim, allocate, backfill, preempt"`.
```bash
helm install --name volcano-release --set basic.scheduler_config_file=volcano-scheduler-ci.conf
```


#### Does preemption happen with cores?

```
kubectl create -f t1/queues.yaml
kubectl create -f t1/jobs-p1-cpu.yaml
kubectl create -f t1/jobs-p2-cpu.yaml
```

#### VCCTL

https://volcano.sh/en/docs/cli/

https://github.com/volcano-sh/volcano/releases/download/v1.1.0/volcano-v1.1.0-linux-gnu.tar.gz


```
vcctl job list 
vcctl job delete --name jobs-p2 
```

*Deleting a queue* - queue needs to be closed first
```
vcctl queue operate --name q-person-2 --action close 
vcctl queue delete --name q-person-2
```

```
vcctl job run --filename t1/jobs-p1-cpu.yaml
vcctl job run --filename t1/jobs-p2-cpu.yaml
```
