
# YuniKorn scheduler

<https://yunikorn.apache.org/>

The feature-list looks promising, and these hierarchical queues could maybe map to labs/students:  
<https://yunikorn.apache.org/docs/get_started/core_features>  
<https://yunikorn.apache.org/docs/user_guide/queue_config>  

>     queues can have hierarchical structure
>     each queue can be preset with min/max capacity where min-capacity defines the guaranteed resource and the max-capacity defines the resource limit (aka resource quota)
>     tasks must be running under a certain leaf queue
>     queues can be static (loading from configuration file) or dynamical (internally managed by YuniKorn)
>     queue level resource fairness is enforced by the scheduler
>     a job can only run under a specific queue

It appears to have a mechanism for queue-level and namespace-level quotas.  
<https://yunikorn.apache.org/docs/user_guide/resource_quota_management>


## My interpretation

We define a hierarchy of [queues](https://yunikorn.apache.org/docs/user_guide/queue_config/).  
Each queue can have resource guarantees and limits.

When a pod is created, the [*placement rules*](https://yunikorn.apache.org/docs/user_guide/placement_rules/) decide to which queue it goes.
For example this kind of rule will place in a `{namespace}.{user}` queue:
```yaml
placementrules:
- name: user
  create: true
  parent:
    name: tag
    value: namespace
```
(However, right now they say their software does not yet read user data from Kubernetes)

I made an prototype queue definition [my_queues_static.yaml](my_queues_static.yaml):

* `department` - global limits
  * `lab1` - lab's namespace
    * `person-c`
  * `lab2` - lab's namespace
    * `person-a`
    * `person-b`

And define resources for these queues. Since each pod requests 1 core, the setup can run maximally 4 pods at once.
We limit each lab's resources to 3 cores.
```yaml
queues:
- name: root
  submitacl: "*"
  queues:
  - name: department
    resources:  
      max:
        vcore: 4000
        memory: 2200
    queues:
    - name: lab1
      parent: true # allow creating sub-queues per user
      resources:
        # guaranteed:
        #   vcore: 1000
        #   memory: 512
        max:
          vcore: 3000
          memory: 1600
      queues:
        - name: person-c
          resources:
            guaranteed:
              vcore: 1000
              memory: 512

    - name: lab2
      parent: true # allow creating sub-queues per user
      resources:
        # guaranteed:
        #   vcore: 1000
        #   memory: 512
        max:
          vcore: 3000
          memory: 1600
      queues:
      - name: person-a
        resources:
          guaranteed:
            vcore: 1000
            memory: 512
      - name: person-b
        resources:
          guaranteed:
            vcore: 1000
            memory: 512
```


## Experiment

* Setup local kubernetes cluster
  * <https://minikube.sigs.k8s.io/docs/start/>
  * download minikube executable to `bin/minikube`  
	`curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
  * download [helm](https://github.com/helm/helm/releases) to `bin/helm`
  * install docker, add myself to docker group, logout, login  
	`sudo apt install docker.io`  
	`sudo adduser my_user docker`
  * create cluster  
	We set the number of cores to 12, instead of default 2, because YuniKorn wants at least 4.  
	`bin/minikube start --cpus 12`  
	`minikube addons enable metrics-server`
  * The cluster is automatically added to `~/.kube/config`, we can switch it by editing `current-context: minikube`

* Install YuniKorn <https://yunikorn.apache.org/docs/>  
	```sh
	bin/helm repo add yunikorn  https://apache.github.io/incubator-yunikorn-release
	bin/helm repo update
	kubectl create namespace yunikorn
	bin/helm install yunikorn yunikorn/yunikorn --namespace yunikorn
	```
	
* Web UIs  
	```sh
	bin/minikube dashboard
	# yunikorn dashboard at localhost:9889
	kubectl port-forward svc/yunikorn-service 9889:9889 -n yunikorn
	kubectl port-forward svc/yunikorn-service 9080:9080 -n yunikorn
	```

* **YuniKorn definition of queues** is stored in something called ConfigMaps.
	Create:  
	`kubectl create configmap yunikorn-configs --namespace yunikorn --from-file=queues.yaml`  
	Edit:  
	`KUBE_EDITOR="code --wait" kubectl edit configmaps yunikorn-configs --namespace yunikorn`  
  * They claim that this definition hot-reloads, but my experience does not confirm it. We can restart the scheduler with:
	```sh
	kubectl scale -n yunikorn deployment yunikorn-scheduler --replicas=0
	kubectl scale -n yunikorn deployment yunikorn-scheduler --replicas=1
	```

* Edit the YuniKorn queue config to my example [my_queues_static.yaml](my_queues_static.yaml).

* The experiment in `experiment.sh` creates 5 pods for each of the 3 users (person-a, person-b, person-c). Pod configs are in [2_pod_yuni](./2_pod_yuni).
  * Each person has their own queue.
	We set the global limit to 4 cores, so they can not run all at once.
	We observe how the scheduler balances these pods.
  * First we create the 5 pods for `person-c` in `lab1`. The lab quota of 3 cores is honored and only 3 are running, the remaining 2 are pending.
  * Then we create 5 pods each for `person-a` and `person-b` in `lab2`.
	Only one of those pods gets scheduled however.
  * **We did not observe desired preemption of `person-c`'s pods**

`bash experiment.sh`
```
Person C from LAB1 creates pods:
job.batch/batch-test-l1-c created
The quota of the LAB1 is 3, so 3 pods should be running
NAMESPACE              NAME                                             READY   STATUS             RESTARTS   AGE
...
lab1                   batch-test-l1-c-4jhln                            1/1     Running            0          15s
lab1                   batch-test-l1-c-5pds6                            0/1     Pending            0          15s
lab1                   batch-test-l1-c-cstsw                            1/1     Running            0          15s
lab1                   batch-test-l1-c-gblpt                            0/1     Pending            0          15s
lab1                   batch-test-l1-c-shv5v                            1/1     Running            0          15s
yunikorn               yunikorn-admission-controller-6b6d4bd5bc-zq67w   0/1     CrashLoopBackOff   4          3m
yunikorn               yunikorn-scheduler-65ff49654b-9xv9t              2/2     Running            1          3m20s

Persons A and B from LAB2 create their pods
job.batch/batch-test-l2-a created
job.batch/batch-test-l2-b created

Balancing of 3 users accross 2 labs
NAMESPACE              NAME                                             READY   STATUS             RESTARTS   AGE
...
lab1                   batch-test-l1-c-4jhln                            1/1     Running            0          35s
lab1                   batch-test-l1-c-5pds6                            0/1     Pending            0          35s
lab1                   batch-test-l1-c-cstsw                            1/1     Running            0          35s
lab1                   batch-test-l1-c-gblpt                            0/1     Pending            0          35s
lab1                   batch-test-l1-c-shv5v                            1/1     Running            0          35s
lab2                   batch-test-l2-a-56kjj                            0/1     Pending            0          15s
lab2                   batch-test-l2-a-75nv9                            0/1     Pending            0          15s
lab2                   batch-test-l2-a-9jx6k                            0/1     Pending            0          15s
lab2                   batch-test-l2-a-bxrsq                            0/1     Pending            0          15s
lab2                   batch-test-l2-a-zbf6r                            1/1     Running            0          15s
lab2                   batch-test-l2-b-6x6p8                            0/1     Pending            0          15s
lab2                   batch-test-l2-b-bn8hq                            0/1     Pending            0          15s
lab2                   batch-test-l2-b-jnznk                            0/1     Pending            0          15s
lab2                   batch-test-l2-b-mg4lw                            0/1     Pending            0          15s
lab2                   batch-test-l2-b-pdmft                            0/1     Pending            0          15s
yunikorn               yunikorn-admission-controller-6b6d4bd5bc-zq67w   0/1     CrashLoopBackOff   5          3m20s
yunikorn               yunikorn-scheduler-65ff49654b-9xv9t              2/2     Running            1          3m40s
```

### Conclusions

**+** Hierarchical queues can express our administrative organization.

**+** Works with existing Namespaces and Pods.

**-** There is a concept of *applications* (Pods belong to applications, applications get put into queues).
 This is an internal representation of the scheduler and not accessible from kubectl.
 We have to specify an `applicationId` for each Pod, I am afraid the application IDs may accidentally conflict between users.

**-** No one uses this yet, so the only thing to read is the documentation.

We should ask:

**?** **Preemption** is mentioned in the docs, but we did not observe it. It is implemented, how to get it to happen?

**?** Can it manage resource limits on **GPUs**? So far we have only seen limits on *vcores* and *memory*.

