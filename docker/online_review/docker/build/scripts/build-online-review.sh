#! /bin/bash
echo 'build online-review'
rm -rf /root/deployment/jboss-4.0.2

cp -n /root/config/online_review/build.properties.docker /root/online_review/build.properties
cp -n /root/config/online_review/token.properties.docker /root/online_review/token.properties

cd /root/deployment
tar xzf /root/jboss-4.0.2.tar.gz

cd /root/online_review

export MAVEN_OPTS="-Dhttps.protocols=TLSv1.2"

mvn install:install-file -Dfile=lib/shared/shared.jar -DgroupId=tc-components -DartifactId=shared -Dversion=1.0.0 -Dpackaging=jar
mvn install:install-file -Dfile=lib/shared/catalog.jar -DgroupId=tc-components -DartifactId=catalog -Dversion=1.0.0 -Dpackaging=jar
mvn install:install-file -Dfile=lib/tcs/security_ejb/Security.jar -DgroupId=tc-components -DartifactId=security -Dversion=1.0.0 -Dpackaging=jar
mvn install:install-file -Dfile=lib/tcs/user_ejb/User.jar -DgroupId=tc-components -DartifactId=User -Dversion=1.0.0 -Dpackaging=jar
mvn install:install-file -Dfile=lib/tcs/id_generator/3.0.2/id_generator.jar -DgroupId=tc-components -DartifactId=id_generator -Dversion=3.0.2 -Dpackaging=jar
mvn install:install-file -Dfile=lib/tcs/tc_id_generator.jar -DgroupId=tc-components -DartifactId=tc_id_generator -Dversion=1.0.0 -Dpackaging=jar
mvn install:install-file -Dfile=lib/third_party/jive/jivebase.jar -DgroupId=tc-components -DartifactId=jivebase -Dversion=1.0.0 -Dpackaging=jar
mvn install:install-file -Dfile=lib/third_party/jive/jiveforums.jar -DgroupId=tc-components -DartifactId=jiveforums -Dversion=1.0.0 -Dpackaging=jar

mvn clean package

mkdir -p /root/deployment/jboss-4.0.2/server/default/deploy/online_review.war 
cp -rf /root/online_review/target/online_review.war/* /root/deployment/jboss-4.0.2/server/default/deploy/online_review.war/.

mkdir /root/deployment/jboss-4.0.2/online-review-conf
cp -rf /root/online_review/conf/* /root/deployment/jboss-4.0.2/online-review-conf
cp -rf /root/online_review/jboss_files/lib/* /root/deployment/jboss-4.0.2/server/default/lib/.
cp -rf /root/online_review/jboss_files/conf/* /root/deployment/jboss-4.0.2/server/default/conf/.
cp -rf /root/online_review/jboss_files/deploy/* /root/deployment/jboss-4.0.2/server/default/deploy/.

mkdir -p /root/deployment/jboss-4.0.2/server/default/deploy/static.ear/static.war
cp -rf /root/online_review/web/* /root/deployment/jboss-4.0.2/server/default/deploy/static.ear/static.war/.
