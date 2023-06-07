# Running `vscode` remotely on RunAI containers

This tutorial explains how to set your `vscode` up to execute/debug code/notebooks remotely on the RunAI container, resulting in a workflow that feels like your laptop had a GPU.

### Content
1. [One time setup](#one-time-setup)
2. [Daily workflow](#daily-workflow)
3. [Troubleshooting](#troubleshooting)

## One time setup:
This approach uses an SSH connection to the node, so we need to have an SSH server running. This is already the case for iccvlabsrvX.iccluster.epfl.ch. For RunAI, the image bases provided by Krzysztof activate it as well (with a caveat discussed later).

1. We need to create an ssh key. Execute
```bash
    ssh-keygen -t ed25519 -C "michal.tyszkiewicz@epfl.ch"
```
You will be prompted for save location and password. You can give it a name like `runai`. On MacOS the utility doesn't seem to expand `~` so you need to write `/Users/jatentaki/.ssh/runai` instead. `jatentaki` is my username on my laptop, swap it out for yours. The password will be required whenever using the key, which is quite a lot, so I'd suggest leaving it empty :)

This will create two files, `/Users/jatentaki/.ssh/runai` and `/Users/jatentaki/.ssh/runai.pub`. Open the `.pub` and the content should look like
```
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETtlUeVXvI+iM6Iqz202CEBekvjkVGCMuR1PmatoYFX michal.tyszkiewicz@epfl.ch
```
As the extension suggests, it is a public key and you don't need to be very secretive with it :)

2. You now want to create a new interactive job where you add the two extra flags `-e SSH_PUBLIC_KEY` and `-e SSH_PORT`. The port value is arbitrary. The final command will be explained later, for now you can use just `sleep 12h`.
```
    runai submit job_name \
        --interactive \
        -e SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkvppGK5aa8MdXM5FDQiwGP6+lJaUHLqh5lCHDiST1E michal.tyszkiewicz@epfl.ch" \
        -e SSH_PORT=2500
        --command -- "/opt/lab/setup_and_run_command.sh 'sh /cvlabdata2/home/tyszkiew/vscode.sh'"
```
The `-e` flag defines an environment variable in the docker container. Krzysztof's base images read those two envvars and start an SSH server using the key and port. Note that the `SSH_PUBLIC_KEY` is defined as the content of `runai.pub`, in double quotes (`"`).

3. Once the pod is up and running you can verify that all went well
```
    jatentaki@tuna ~> runai logs job_name
    --- lab setup ---
    --- /opt/lab/setup_steps/10_cluster_user.sh ---
    Setting up user tyszkiew
    Creating user tyszkiew
    User setup done
    --- /opt/lab/setup_steps/14_ssh.sh ---
    SSH activating
    Listening on 2500
    --- lab setup complete ---
```
If `14_ssh.sh` didn't fire, that means something went wrong - see the end for troubleshooting. If the SSH is up and running, we need to forward the port from the node to our computer. To my best knowledge this is not covered by the `runai` command line utility so we will need to use `kubectl`. This has the disadvantage that it names the jobs differently than `runai` does, but usually it just appends `-0-0` to their name. In any case you can see running jobs with `kubectl get pods`.

4. In a new terminal execute AND LEAVE RUNNING in the background
```
    kubectl port-forward pods/job_name-0-0 2500:2500
```
At this point we have the node's SSH server available as if it was running locally.

5. Fire up vscode, bring up the menu (cmd + shift + p) and type in `Remote-SSH: connect to Host...`. This may require having installed the microsoft official SSH extension for vscode - I don't remember anymore if it's included by default.

6. Pick `Configure SSH Hosts...`, then any of the suggested config files (your preference where you save it) and add the following entry
```
    Host RunAI
     HostName 127.0.0.1
     User tyszkiew
     Port 2500
     IdentityFile /Users/jatentaki/.ssh/runai
```
Note that the IdentityFile is the non-public of the two created earlier by `ssh-keygen` and the HostName is 127.0.0.1 or, in other words, the localhost. This is because we will be using this config while forwarding the node's ports to localhost. Save the file.

7. Bring up `Remote-SSH: connect to Host...` again and choose the newly-created RunAI. It should connect (possibly asking for the ssh key password) and give you a window where you can browse through the files on the remote machine, open and run arbitrary projects. We're almost done.

8. A small inconvenience is that vscode on the remote machine will have a different (and initially empty) set of extensions than the one on your machine. This would be a one time problem, but since it saves them on /home/tyszkiew, which is wiped clean after each job ends, it gets annoying. For that reason it is convenient to create a file called `/cvlabdata2/home/tyszkiew/vscode.sh` with the following content:
```bash
    #!/bin/bash

    rm -R /home/tyszkiew/.vscode-server
    ln -s /cvlabdata2/home/tyszkiew/.vscode-server /home/tyszkiew/.vscode-server
    sleep 12h
```
This removes the fresh vscode config directory and replaces it with a symlink to a persistent one stored on /cvlabdata2. This is the script we told `runai` to execute when submitting the job.
 
## Daily workflow
Once the setup is complete, the workflow is
* Submit a job with flags as in step 2. above
* Forward the port as in step 4. above
* Fire up vscode, bring up the menu and connect to host as in step 7. above

## Troubleshooting
### Issues with SSH startup
I have experienced some issues with starting the SSH daemon on the node with Krzysztof's images. The fix was to replace his invocation of `sshd` with an absolute path. In other words modify lines [33](https://gitlab.com/Adynathos/cvlab-kubernetes-guide/-/blob/e77e1accbef9f966a892d9f91cc619e435ef6635/images/lab-base/setup_steps/14_ssh.sh#L33) and 35 from `sshd` to `/usr/sbin/sshd`. This unfortunately requires rebuilding the image. To see if that helps, you can quickly try mine at `ic-registry.epfl.ch/cvlab/tyszkiew/pytorch:torch200`. I should be very close to Krzysztof's, with python 3.10 and pytorch 2.0.

### SSH keys have wrong permissions
Some programs refuse to use SSH keys with improperly set permissions (i.e. private keys which have read permissions for other users). If you see any errors along these lines, adjust the permissions with `chmod XXX` following https://superuser.com/a/215506/1780189. I don't remember if I encountered that with the setup I'm describing here.

### Certain links shown in stack traces in in notebooks fail to open
This is a known issue :(