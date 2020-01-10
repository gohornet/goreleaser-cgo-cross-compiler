FROM dockercore/golang-cross

ENV GORELEASER_VERSION=0.123.3
ENV GORELEASER_SHA=cad997014e5c6a462488757087db4145c2ae7d7d73a29cb62bbfd41f18ccea30
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

ENV GOLANG_VERSION=1.13.5
ENV GOLANG_SHA=512103d7ad296467814a6e3f635631bd35574cab3369a97a323c9a585ccaa569
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

ENV MUSL_x86_64_DOWNLOAD_FILE=x86_64-linux-musl-native.tgz
ENV MUSL_x86_64_DOWNLOAD=https://cross.iotmod.de/${MUSL_x86_64_DOWNLOAD_FILE}
ENV MUSL_AARCH64_DOWNLOAD_FILE=aarch64-linux-musl-cross.tgz
ENV MUSL_AARCH64_DOWNLOAD=https://cross.iotmod.de/${MUSL_AARCH64_DOWNLOAD_FILE}
ENV MUSL_ARMHF_DOWNLOAD_FILE=arm-linux-musleabihf-cross.tgz
ENV MUSL_ARMHF_DOWNLOAD=https://cross.iotmod.de/${MUSL_ARMHF_DOWNLOAD_FILE}
ENV MUSL_ARMV7L_DOWNLOAD_FILE=armv7l-linux-musleabihf-cross.tgz
ENV MUSL_ARMV7L_DOWNLOAD=https://cross.iotmod.de/${MUSL_ARMV7L_DOWNLOAD_FILE}

RUN  wget ${GORELEASER_DOWNLOAD_URL}; \
			echo "$GORELEASER_SHA $GORELEASER_DOWNLOAD_FILE" | sha256sum -c - || exit 1; \
			tar -xzf $GORELEASER_DOWNLOAD_FILE -C /usr/bin/ goreleaser; \
			rm $GORELEASER_DOWNLOAD_FILE;

RUN  wget ${GOLANG_DOWNLOAD_URL}; \
			echo "$GOLANG_SHA $GOLANG_DOWNLOAD_FILE" | sha256sum -c - || exit 1; \
			rm -rf /usr/local/go; \
			tar -xzf $GOLANG_DOWNLOAD_FILE -C /usr/local; \
			rm $GOLANG_DOWNLOAD_FILE; 

RUN  mkdir /etc/musl;

RUN  wget ${MUSL_x86_64_DOWNLOAD}; \
			tar -xzf ${MUSL_x86_64_DOWNLOAD_FILE} -C /etc/musl/; \
			rm ${MUSL_x86_64_DOWNLOAD_FILE};
RUN	 wget ${MUSL_AARCH64_DOWNLOAD}; \
			tar -xzf ${MUSL_AARCH64_DOWNLOAD_FILE} -C /etc/musl/; \
			rm ${MUSL_AARCH64_DOWNLOAD_FILE};
RUN	 wget ${MUSL_ARMHF_DOWNLOAD}; \
			tar -xzf ${MUSL_ARMHF_DOWNLOAD_FILE} -C /etc/musl/; \
			rm ${MUSL_ARMHF_DOWNLOAD_FILE};
RUN	 wget ${MUSL_ARMV7L_DOWNLOAD}; \
			tar -xzf ${MUSL_ARMV7L_DOWNLOAD_FILE} -C /etc/musl/; \
			rm ${MUSL_ARMV7L_DOWNLOAD_FILE};

RUN  find /etc/musl/ -type f -executable \( -exec sh -c 'file -b "$1" | grep -q executable' Test {} \; -o -exec chmod a-x {} \; \);

RUN apt-get update && apt-get install -y build-essential \
			gcc-arm-linux-gnueabi g++-arm-linux-gnueabi gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
			libc6-dev-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev \
			gcc-mingw-w64 g++-mingw-w64 \
			gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
	apt-get -y autoremove && \
	wget -O docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz" && \
	tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ && \
	rm docker.tgz

CMD ["goreleaser", "-v"]