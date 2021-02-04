
sleep 1

echo "Person C from LAB1 creates pods:"
kubectl create -f 2_pod_yuni/batch_yuni_step1.yaml
sleep 15

echo "The quota of the LAB1 is 3, so 3 pods should be running"
kubectl get pods -A

sleep 5

echo "Persons A and B from LAB2 create their pods"
kubectl create -f 2_pod_yuni/batch_yuni_step2.yaml
sleep 15

echo "Balancing of 3 users accross 2 labs"
kubectl get pods -A

