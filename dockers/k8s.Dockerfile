FROM kpango/dev-base:latest AS kube-base

ENV ARCH amd64
ENV ARCH1 x86_64
ENV OS linux
ENV GITHUB https://github.com
ENV GOOGLE https://storage.googleapis.com
ENV RELEASE_DL releases/download
ENV RELEASE_LATEST releases/latest
ENV LOCAL /usr/local
ENV BIN_PATH ${LOCAL}/bin
ENV TELEPRESENCE_VERSION 0.108

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.8 \
    python3-setuptools \
    python3-pip \
    python3-venv \
    && mkdir -p "${BIN_PATH}"

FROM kube-base AS kubectl
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectl" \
    && VERSION="$(curl -s ${GOOGLE}/kubernetes-release/release/stable.txt)" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GOOGLE}/kubernetes-release/release/${VERSION}/bin/${OS}/${ARCH}/${BIN_NAME}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}" \
    && "${BIN_PATH}/${BIN_NAME}" version --client

FROM kube-base AS helm
RUN set -x; cd "$(mktemp -d)" \
    && curl "https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3" | bash \
    && BIN_NAME="helm" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS helmfile
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="helmfile" \
    && REPO="roboll/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${BIN_NAME}_${OS}_${ARCH}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}" 

FROM kube-base AS kubectx
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectx" \
    && REPO="ahmetb/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_v${VERSION}_${OS}_${ARCH1}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubens
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectx" \
    && REPO="ahmetb/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && BIN_NAME="kubens" \
    && TAR_NAME="${BIN_NAME}_v${VERSION}_${OS}_${ARCH1}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"


FROM kube-base AS krew
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="krew" \
    && REPO="kubernetes-sigs/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.{tar.gz,yaml}" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && "${PWD}/${BIN_NAME}-${OS}_${ARCH}" install --manifest="${BIN_NAME}.yaml" --archive="${BIN_NAME}.tar.gz" \
    && BIN_NAME="kubectl-krew" \
    && "/root/.krew/bin/${BIN_NAME}" update \
    && mv "/root/.krew/bin/${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}"
    # && mv "/root/.krew/bin/${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    # && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubebox
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubebox" \
    && REPO="astefanutti/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${BIN_NAME}-${OS}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS stern
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="stern" \
    && REPO="wercker/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GITHUB}/${REPO}/${RELEASE_DL}/${VERSION}/${BIN_NAME}_${OS}_${ARCH}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubebuilder
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubebuilder" \
    && REPO="kubernetes-sigs/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_${VERSION}_${OS}_${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${TAR_NAME}/bin/${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kind
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kind" \
    && REPO="kubernetes-sigs/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${BIN_NAME}-${OS}-${ARCH}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubectl-fzf
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectl-fzf" \
    && REPO="bonnefoa/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_${OS}_${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && BIN_NAME="cache_builder" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS k9s
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="k9s" \
    && REPO="derailed/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_Linux_${ARCH1}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS telepresence
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="telepresence" \
    && REPO="telepresenceio/${BIN_NAME}" \
    && curl -fsSLO "${GITHUB}/${REPO}/archive/${TELEPRESENCE_VERSION}.tar.gz" \
    && tar -zxvf "${TELEPRESENCE_VERSION}.tar.gz" \
    && env PREFIX="${LOCAL}" "telepresence-${TELEPRESENCE_VERSION}/install.sh"

FROM kube-base AS kube-profefe-base
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kube-profefe" \
    && REPO="profefe/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_v${VERSION}_Linux_${ARCH1}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && BIN_NAME="kprofefe" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && BIN_NAME="kubectl-profefe" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}"

FROM kube-profefe-base AS kprofefe
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kprofefe" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-profefe-base AS kubectl-profefe
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectl-profefe" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubectl-tree
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectl-tree" \
    && REPO="ahmetb/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_v${VERSION}_${OS}_${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS linkerd
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="linkerd" \
    && curl -sL https://run.linkerd.io/install | sh \
    && mv ${HOME}/.linkerd2/bin/${BIN_NAME}-* "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS octant
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="octant" \
    && REPO="vmware-tanzu/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_${VERSION}_Linux-64bit" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${TAR_NAME}/${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS skaffold
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="skaffold" \
    && REPO="GoogleContainerTools/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${BIN_NAME}-${OS}-${ARCH}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubeval
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubeval" \
    && REPO="instrumenta/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}-${OS}-${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS helm-docs
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="helm-docs" \
    && REPO="norwoodj/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_${VERSION}_Linux_${ARCH1}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubectl-gadget
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="inspektor-gadget" \
    && REPO="kinvolk/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}-${OS}-${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && BIN_NAME="kubectl-gadget" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubectl-rolesum
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectl-rolesum" \
    && REPO="Ladicle/${BIN_NAME}" \
    && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && TAR_NAME="${BIN_NAME}_${OS}-${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${TAR_NAME}/${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kubectl-trace
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kubectl-trace" \
    && REPO="iovisor/${BIN_NAME}" \
    # && VERSION="$(curl --silent ${GITHUB}/${REPO}/${RELEASE_LATEST} | sed 's#.*tag/\(.*\)\".*#\1#' | sed 's/v//g')" \
    && VERSION="0.1.0-rc.1" \
    && TAR_NAME="${BIN_NAME}_${VERSION}_${OS}_${ARCH}" \
    && curl -fsSLO "${GITHUB}/${REPO}/${RELEASE_DL}/v${VERSION}/${TAR_NAME}.tar.gz" \
    && tar -zxvf "${TAR_NAME}.tar.gz" \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS istio
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="istioctl" \
    && curl -L https://istio.io/downloadIstio | sh - \
    && mv "$(ls | grep istio)/bin/${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kpt
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kpt" \
    && curl -fsSLo "${BIN_PATH}/${BIN_NAME}" "${GOOGLE}/kpt-dev/latest/${OS}_${ARCH}/${BIN_NAME}" \
    && chmod a+x "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS k3d
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="k3d" \
    && REPO="rancher/${BIN_NAME}" \
    && wget -q -O - "https://raw.githubusercontent.com/${REPO}/main/install.sh" | bash \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM kube-base AS kustomize
RUN set -x; cd "$(mktemp -d)" \
    && BIN_NAME="kustomize" \
    && REPO="kubernetes-sigs/${BIN_NAME}" \
    && wget -q -O - "https://raw.githubusercontent.com/${REPO}/master/hack/install_kustomize.sh" | bash \
    && mv "${BIN_NAME}" "${BIN_PATH}/${BIN_NAME}" \
    && upx -9 "${BIN_PATH}/${BIN_NAME}"

FROM scratch AS kube

ENV BIN_PATH /usr/local/bin
ENV LIB_PATH /usr/local/libexec
ENV K8S_PATH /usr/k8s/bin
ENV K8S_LIB_PATH /usr/k8s/lib

COPY --from=helm ${BIN_PATH}/helm ${K8S_PATH}/helm
COPY --from=helm-docs ${BIN_PATH}/helm-docs ${K8S_PATH}/helm-docs
COPY --from=helmfile ${BIN_PATH}/helmfile ${K8S_PATH}/helmfile
COPY --from=istio ${BIN_PATH}/istioctl ${K8S_PATH}/istioctl
COPY --from=k3d ${BIN_PATH}/k3d ${K8S_PATH}/k3d
COPY --from=k9s ${BIN_PATH}/k9s ${K8S_PATH}/k9s
COPY --from=kind ${BIN_PATH}/kind ${K8S_PATH}/kind
COPY --from=kprofefe ${BIN_PATH}/kprofefe ${K8S_PATH}/kprofefe
COPY --from=kpt ${BIN_PATH}/kpt ${K8S_PATH}/kpt
COPY --from=krew ${BIN_PATH}/kubectl-krew ${K8S_PATH}/kubectl-krew
COPY --from=krew /root/.krew/index $/root/.krew/index
COPY --from=kubebox ${BIN_PATH}/kubebox ${K8S_PATH}/kubebox
COPY --from=kubebuilder ${BIN_PATH}/kubebuilder ${K8S_PATH}/kubebuilder
COPY --from=kubectl ${BIN_PATH}/kubectl ${K8S_PATH}/kubectl
COPY --from=kubectl-fzf ${BIN_PATH}/cache_builder ${K8S_PATH}/cache_builder
COPY --from=kubectl-gadget ${BIN_PATH}/kubectl-gadget ${K8S_PATH}/kubectl-gadget
COPY --from=kubectl-profefe ${BIN_PATH}/kubectl-profefe ${K8S_PATH}/kubectl-profefe
COPY --from=kubectl-rolesum ${BIN_PATH}/kubectl-rolesum ${K8S_PATH}/kubectl-rolesum
COPY --from=kubectl-trace ${BIN_PATH}/kubectl-trace ${K8S_PATH}/kubectl-trace
COPY --from=kubectl-tree ${BIN_PATH}/kubectl-tree ${K8S_PATH}/kubectl-tree
COPY --from=kubectx ${BIN_PATH}/kubectx ${K8S_PATH}/kubectx
COPY --from=kubens ${BIN_PATH}/kubens ${K8S_PATH}/kubens
COPY --from=kubeval ${BIN_PATH}/kubeval ${K8S_PATH}/kubeval
COPY --from=kustomize ${BIN_PATH}/kustomize ${K8S_PATH}/kustomize
COPY --from=linkerd ${BIN_PATH}/linkerd ${K8S_PATH}/linkerd
COPY --from=octant ${BIN_PATH}/octant ${K8S_PATH}/octant
COPY --from=skaffold ${BIN_PATH}/skaffold ${K8S_PATH}/skaffold
COPY --from=stern ${BIN_PATH}/stern ${K8S_PATH}/stern
COPY --from=telepresence ${BIN_PATH}/telepresence ${K8S_PATH}/telepresence
COPY --from=telepresence ${LIB_PATH}/sshuttle-telepresence ${K8S_LIB_PATH}/sshuttle-telepresence
