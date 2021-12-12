# Arjen Johtamisratkaisujen Alusta, ARJA
## Yleistä
Projekti sisältää kokoelman Ansible-skriptejä, joka alustaa kohdepalvelimen sekä asentaa sille määritetyn Docker-palvelukonttipinon. Kontit voidaan ottaa käyttöön myös ilman Ansiblea hyödyntäen docker-compose:a.

### Mikä on Ansible ?
Ansible on IT-järjestelmien ja -palveluiden automatisointityökalu, joka vähentää manuaalista käsityötä järjestelmän käyttöönotto- ja käyttövaiheissa. 

[Wikipedia](https://fi.wikipedia.org/wiki/Ansiibeli): Sana Ansiibeli (engl. ansible) on hypoteettinen laite, jonka avulla voi viestiä valon nopeutta suuremmalla nopeudella. 

## Käyttöönotto
Projektin käyttöönotto ja palveluiden asentaminen sisältää kolme päävaihetta:
 1. Ansible-hostin alustaminen. Tarkoittaa tietokonetta, joka ajaa ansible-playbook:t.
 2. Kohdetietokoneen/-koneiden alustaminen. Tarkoittaa tietokonetta/palvelinta, jolle järjestelmäpalvelut otetaan käyttöön. Kohdekone on oltava IP-verkon kautta saatavissa Ansible-host:lle.
 3. Ansible-projektin teknisten parametrien määrittäminen ennen playbookien ajoa.

### 1. Ansible-host:n alustaminen
Alusta tietokone, jolta ajat Ansiblea. Esim MAC, Ubuntu Desktop tai Win10. Ansible-komennot ajatutuvat linux:lla, joten Windowsille tarvitaan esim WSL:ssä ajettava Ubuntu. Ansible:n ajantasaisin versio (23.11.2021: ansible-core 2.11.6) löytyy Python pakettikirjaston (PyPI) kautta ja asennettavissa PIP:llä. APT-pakettimanagerin kautta löytyy vanhempi versio (23.11.2021: ansible-core 2.9.6).

#### 1.a) Tietokoneen peruspalvelut ja -ohjelmakirjastot
Python version 3 vaaditaan (huom. sudo-asennus).
```
$ sudo apt -y install python3-pip python-is-python3
$ pip install --upgrade pip wheel
$ pip install ansible
```

Ansible-host:lle asennetaan yhteisölisäosat docker:lle ja kryptografisille palveluille sekä SSH-salasanaa kysyvä ohjelmakirjasto:
```
$ ansible-galaxy collection install community.docker
$ ansible-galaxy collection install community.crypto
$ sudo apt -y install sshpass
```

Ansible-host asentaa kohdekoneelle docker-palvelukontit ja tämä hallintayhteys hyödyntää [Docker context:ia](https://docs.docker.com/engine/context/working-with-contexts/). Näin ollen Ansible-host:lle tarvitaan asentaa myös Docker, vaikka varsinaisia palvelukontteja ei Ansible-host:lle asennettaisikaan. Docker on asennettavissa eri käyttöjärjestelmille ja ohjeistusta tästä [ohjeesta](https://docs.docker.com/get-docker/)

#### 1.b) Etäyhteys VSCodeen
[RMATE-kirjasto](https://pypi.org/project/rmate/) helpottaa elämää, kun Visual Studio Code -editorilla voi ottaa SSH-etäyhteyden Ansible-hostiin (mikäli Ansiblea ajetaan etäyhteden kautta):
```
$ pip install rmate
```

Tämän jälkeen VS Code -editorin kautta voidaan ottaa SSH-etäyhteys esim Ansible-host:lle tämän [ohjeen](https://code.visualstudio.com/docs/remote/ssh) mukaisesti.

#### 1.c) ARJA-Projektin lataaminen Ansible-host:lle
Kopioi tämä projekti esim git-komennolla
```
$ git clone https://github.com/muutttu/arja.git
```
Tämän jälkeen siirry kansioon arja/ansible

Mikäli Ansible-host:lta puuttuu git-ohjelmisto, se asennetaan esim tämän [ohjeen](https://github.com/git-guides/install-git) mukaisesti.

### 2. Kohdekoneen alustaminen
Kohdekone, sisältäen ns Docker-host:n, voi olla erillinen palvelin erillään Ansible-host:sta. Kohdekone voi olla fyysinen tai virtualisoitu palvelin esimerkiksi julkisen pilvipalveluntarjoajan infrasta.

#### 2.a) Käyttöjärjestelmän valinta
Nykyinen ARJA-projektin konfiguraatio (11.12.2021) on tehty ja testattu käyttäen Ubuntu Server 20.04 LTS -käyttöjärjestelmää varten, joten tämä on myös suositeltu kohdekoneen käyttöjärjestelmä. Käyttöjärjestelmän asennus esim tämän [ohjeen](https://ubuntu.com/download/server) mukaisesti.

#### 2.b) Internet-yhteys ja tarvittavat tietoliikenneportit
Kohdekoneelle tarvitaan molempisuuntainen laajakaistainen Internet-yhteys, eli sen pitää sallia sisääntulevat yhteydet. Palveluiden asentamista ja käyttöä varten tarvitaan aukaista seuraavat portit:
  - TCP22: SSH
  - TCP80: HTTP
  - TCP443: SSL/HTTPS
  - TCP9000: Portainer-hallintayhteys
  - TCP5443: Ejabberd TLS/HTTPS
  - TCP5280: Ejabberd HTTP
  - TCP5222+UDP5222: XMPP Client

On suositeltavaa, että kohdekoneen julkista IP-osoitetta varten tehdään verkkonimi julkisessa nimipalvelussa. Myös dynaaminen DNS käy, kuten [dy.fi](https://www.dy.fi/).

### 3. Ansible-projektin teknisten parametrien määrittäminen ennen playbookien ajoa.
Siirry kansioon arja/ansible ja avaa hosts.yml tiedosto. Ko tiedostoon asetetaan kaikki alustettavat kohdekoneet ja perusparametrit. Tiedostoon on kirjattu valmiiksi 2 laiteryhmää "ubuntu" ja "demogroup". Poista "ubuntu"-ryhmän rivien kommentit (#-merkit), jotta kohdasta tulee seuraavanlainen:
```
    ubuntu: # Tämä on laiteryhmän esimerkki
      hosts:
        palvelin-001: # Tämä on esimerkki laitteen nimestä
          ansible_host: 127.0.0.1 # !! Kohdekoneen IP-osoite tai verkkonimi tähän !!
          # Kohdekoneen tarvitsemat verkkoparametrit tähän alle:
          #ansible_ssh_private_key_file: ""
          #ansible_ssh_pass: "huippusalainensalasana"
          #ansible_sudo_pass: "toinensalainensalasana"
          docker_host_domain_name: jokunimi.esimerkki.net
          certbot_email: osoite@esimerkki.net
```
- parametri "palvelin-001" tarkoittaa kohdekoneelle annettavaa nimialiasta, joka voi olla mitä vaan.
- Jos kohdepalvelimelle otetaan SSH-yhteys sertifikaatin avulla, konfiguroi muuttuja "ansible_ssh_private_key_file", ja mikäli SSH-salasanalla niin sitten korjaa muuttujat "ansible_ssh_pass" ja "ansible_sudo_pass". Yleensä nämä ovat samat. On suositeltavaa, että kohdekoneen kirjautumistietoja ei tallenneta selkokielellä vaan ne tallennetaan [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html):iin.
- muuttuja "docker_host_domain_name" kohdekonetta varten tehty julkinen verkko-osoite. Mielellään edellä mainittu julkinen verkkonimi.
- muuttuja "certbot_email" tarkoittaa ylläpitäjän sähköpostiosoitetta, johon läheteään Certbot:n tiedotteita mm SSL-sertifikaattien päivitystarpeesta.

Ansible-skriptien toiminnasta tarkemmin tiedostossa arja/ansible/README.md

## Käyttö
Projektin ansible-playbook:t ovat kansiossa ansible, jossa koko projekti play:t ajetaan kommennolla:
```
$ ansible-playbook './site.yml'
```
Komento ajetaan nimenomaan ansible-kansiossa, jotta site.yml-playbook ottaa hosts.yml-tiedoston käyttöön.

## Projektin olennaiset tiedostot
Ansible-playbook 'site.yml' on ns päädokumentti, jonka kautta ajetaan seuraavat osiot.

### Kohdekoneiden SSH-yhteystesti
Playbook 'testssh.yml' tekee ansiblen ssh-pingin jokaiselle hosts.yml-tiedostossa määritetylle kohdekoneelle.

### Kohdekoneiden alustus (bootstrap)
Playbook 'bootstrap.yml' alustaa kohdekoneen ja asentaa tarvittavat ohjelmapaketit ja -kirjastot sekä konfiguraatiot. Toistaiseksi testaus on tehty Ubuntu Server 20.04 -käyttöjärjestelmällä.

### Docker-host:n alustus ja konttipalvelut
Playbook 'docker.yml' tekee kohdekoneesta Docker-hostin ja asentaa sille paketit docker ja docker-compose. Konttipalvelut tuotetaan tekemällä image (docker-compose:lla) sekä asentamalla palvelukontit. Ansible-skripti tuottaa seuraavat konttipalvelut:
 - Ejabberd-chat-sovellus
 - Nginx www-proxy (ml testisivut)
 - Flask web-sovellus (sovellusta jatkokehitetään)
 - PostgreSQL-Tietokanta (käytettäväksi web-sovelluksen kanssa)
 - Let's Encrypt Certbot, joka tuottaa SSL-sertifikaatit
 - Portainer, jolla hallinnoidaan Docker-ympäristöä

### Yhteydet
 - Ejabberd:iin liitytään xmpp-clientillä, esim Xabber (Android), ChatSecure (iOS) tai Pidgin (Win/Ubuntu)
 - Nginx:n yhteystesti osoitteessa http(s)://{verkko-osoite}/health-check
 - Flask-sovellus osoitteessa http(s)://{verkko-osoite}/flask
 - Portainer osoitteessa http(s)://{verkko-osoite}:9000 (ensikirjautumissa asetetaan admin-tunnus ja salasana)

## Lisenssi
GNU General Public License v3.0