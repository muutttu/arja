# Arjen Johtamisratkaisujen Alusta, ARJA
## Yleistä
Projekti sisältää Ansible-skriptin, joka alustaa kohdepalvelimen sekä asentaa sille Docker-konttipinon. Kontit voidaan ottaa käyttöön myös ilman Ansiblea hyödyntäen docker compose:a. 

## Käyttöönotto
### Ansible-host
Alusta tietokone, jolta ajat Ansiblea. Esim MAC, Ubuntu Desktop tai Win10. Ansible-komennot ajatutuvat linux:lla, joten Windowsille tarvitaan esim WSL:ssä ajettava Ubuntu. Ansible:n ajantasaisin versio (23.11.2021: ansible-core 2.11.6) löytyy Python pakettikirjaston (PyPI) kautta ja asennettavissa PIP:llä. APT-pakettimanagerin kautta löytyy vanhempi versio (23.11.2021: ansible-core 2.9.6).

Python version 3 vaaditaan (huom. sudo-asennus).
```
$ sudo apt -y install python3-pip python-is-python3
$ pip install --upgrade pip wheel
$ pip install ansible
```

Lisäksi tarvitaan ansibleen yhteisölisäosa docker:lle ja SSH-salasanaa kysyvä ohjelmakirjasto:
```
$ ansible-galaxy collection install community.docker
$ sudo apt -y install sshpass
```

### Etäyhteys VSCodeen
RMATE helpottaa elämää, kun Visual Studio Code -editorilla voi ottaa SSH-etäyhteyden esim Ansible-hostiin (mikäli Ansiblea ajetaan etäkoneella):
```
$ pip install rmate
```
### Projektin lataus
Kopioi tämä projekti esim git-komennolla
```
$ git clone https://github.com/muutttu/pilvibittiweb.git
```
Siirry kansioon arja/ansible

### Kohdepalvelimen parametrien asentaminen
Muokkaa tiedostoa hosts.yml oman verkkoympäristösi mukaiseksi. Esimerkissä on laiteryhmä 's7home', johon kuuluu 1 laite nimeltä 'rivoriitta.s7'. Laitetta varten tarvitaan IP-osoite (kenttä 'ansible_host: 1.2.3.4') sekä muuttujat/vars (mm ssh-parametrit) tiedostossa group_vars/s7home.

Docker-palveluja varten tarvittavat asetukset ovat docker-kansion tiedostossa .env.

## Käyttö
Projektin ansible-playbook:t ovat kansiossa ansible, jossa koko projekti play:t ajetaan kommennolla:
```
$ ansible-playbook './site.yml'
```
Komento ajetaan nimenomaan ansible-kansiossa, jotta playbook ottaa hosts.yml-tiedoston käyttöön.


## Lopputulos
Ansible playbook 'site.yml' ajaa seuraavat kommennot:

### Kohdekoneiden yhteystesti
Playbook 'testssh.yml' tekee ansiblen ssh-pingin

### Kohdekoneiden alustus (bootstrap)
Playbook 'bootstrap.yml' alustaa kohdekoneen ja asentaa sille olennaiset ohjelmapaketit ja -kirjastot. Toistaiseksi testaus on tehty Ubuntu Server 20.04 -palvelimella, jota varten on komennot tiedostossa roles/bootstrap_ubuntu/tasks/main.yml

### Docker-host:n alustus ja konttipalvelut
Playbook 'docker.yml' tekee kohdekoneesta Docker-hostin ja asentaa sille paketit docker ja docker-compose. Konttipalvelut tuotetaan tekemällä image (compse:lla) sekä asentamalla kontin imagen mukaisesti. Ansible-skripti tuottaa seuraavat konttipalvelut:
 - Ejabberd-chat-sovellus
 - Nginx www-proxy
 - Flask web-sovellus (testisivu)
 - PostgreSQL-Tietokanta (käytettäväksi web-sovelluksen kanssa)
 - Let's Encrypt Certbot, joka tuottaa Nginx:lle SSL-sertifikaatit
 - Portainer, jolla voi hallinnoida Docker-ympäristöä

### Yhteydet
 - Ejabberd:iin liitytään xmpp-clientillä, esim Xabber (Android), ChatSecure (iOS) tai Pidgin (Win/Ubuntu)
 - Nginx:n yhteystesti osoitteessa http(s)://[kohde-ip]/health-check
 - Flask-sovellus osoitteessa http(s)://[kohde-ip]/flask
 - Portainer osoitteessa http://[kohde-ip]:9000 (ensikirjautumissa asetetaan admin-tunnus ja salasana)

## Lisenssi
GNU General Public License v3.0