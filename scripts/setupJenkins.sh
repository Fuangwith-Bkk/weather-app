#!/bin/sh

export NS_JENKINS="demo-jenkins"

oc new-project ${NS_JENKINS} --display-name "Jenkins" 
oc new-app jenkins-persistent --param ENABLE_OAUTH=true \
--param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi \
--param DISABLE_ADMINISTRATIVE_MONITORS=true \
-l app.kubernetes.io/name=jenkins \
-n ${NS_JENKINS}

oc set resources dc jenkins --limits=memory=2Gi,cpu=2 --requests=memory=1Gi,cpu=500m -n ${NS_JENKINS}


#oc new-build --strategy=docker -D $'FROM quay.io/openshift/origin-jenkins-agent-maven:4.1.0\n
#   USER root\n
#   RUN curl https://copr.fedorainfracloud.org/coprs/alsadi/dumb-init/repo/epel-7/alsadi-dumb-init-epel-7.repo -o /etc/yum.repos.d/alsadi-dumb-init-epel-7.repo && \ \n
#   curl https://raw.githubusercontent.com/cloudrouter/centos-repo/master/CentOS-Base.repo -o /etc/yum.repos.d/CentOS-Base.repo && \ \n
#   curl http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \ \n
#   DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \ \n
#   yum $DISABLES -y --setopt=tsflags=nodocs install skopeo && yum clean all\n
#   USER 1001' --name=jenkins-agent-appdev -n ${NS_JENKINS}

oc new-build --strategy=docker -D $'FROM registry.access.redhat.com/ubi8/go-toolset:latest as builder\n
ENV SKOPEO_VERSION=v1.0.0\n
RUN git clone -b $SKOPEO_VERSION https://github.com/containers/skopeo.git && cd skopeo/ && make binary-local DISABLE_CGO=1\n
FROM registry.redhat.io/openshift4/ose-jenkins-agent-maven:v4.5.0 as final\n
USER root\n
RUN mkdir /etc/containers\n
COPY --from=builder /opt/app-root/src/skopeo/default-policy.json /etc/containers/policy.json\n
COPY --from=builder /opt/app-root/src/skopeo/skopeo /usr/bin\n
USER 1001' --name=jenkins-agent-appdev -n ${NS_JENKINS}
   
oc get is
oc get pods -w

oc apply -f manifests/jenkins-configmap.yaml -n ${NS_JENKINS}
oc apply -f manifests/weather-bc-pipeline.yaml -n ${NS_JENKINS}

echo "Jenkins Url = $(oc get route jenkins -n demo-jenkins -o jsonpath='{.spec.host}') "






