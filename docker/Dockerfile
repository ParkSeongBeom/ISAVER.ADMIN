FROM repo.isaver.co.kr:5000/tms_base
MAINTAINER S.B. Park <meous@icent.co.kr>

ADD PACKAGES/INSTALL/isaver /isaver
ADD PACKAGES/INSTALL/container/isaver_web /isaver/was/isaver_web
ADD PACKAGES/INSTALL/hasp /isaver/hasp

ENV ISAVER_HOME /isaver
ENV LD_LIBRARY_PATH /isaver/hasp

RUN chmod -R 755 $ISAVER_HOME

EXPOSE 8800
HEALTHCHECK --interval=10s CMD wget -qO- localhost:8800

ADD PACKAGES/SCRIPT/init-web.sh /docker-entrypoint/init.sh
RUN chmod 755 /docker-entrypoint/init.sh

ENTRYPOINT ["/docker-entrypoint/init.sh"]
