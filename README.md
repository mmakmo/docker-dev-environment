# docker-dev-environment

* linux
* [Viron](https://cam-inc.github.io/viron-doc/) : web admin tool
* [Cypress](https://www.cypress.io) : web UI test automation


Memo

* Unlock Jenkins

```
alias xpath="xmllint --html --xpath 2>/dev/null"
curl http://localhost:8080/login?from=%2F | tac | tac|  xpath "/html/head/script[20]" -

curl http://localhost:8080/login?from=%2F | grep -o "security-token"


curl http://localhost:8080/login?from=%2F | grep -o '<title>(.+)</title>'

<input type="hidden" name="Jenkins-Crumb" value="d73b89fbe2337d0d4d9956ee3cd06287">
head > script:nth-child(27)
/html/head/script[20]


<input id="security-token" class="form-control" type="password" name="j_password">
<input type="submit" class="btn btn-primary set-security-key" value="Continue">

TOKEN=$(cat /var/jenkins_home/secrets/initialAdminPassword)
curl -s -o /dev/null -I -w "%{http_code}" -X POST -F 'j_password=${TOKEN}' http://localhost:8080/login?from=%2F


curl -X POST -F 'j_password=${TOKEN}' http://localhost:8080/login?from=%2F

/var/jenkins_home/secrets/initialAdminPassword
```
