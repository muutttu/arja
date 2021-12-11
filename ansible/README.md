# Ansible-projektin kuvaus

## Kohdepalvelimen parametrien asentaminen
Muokkaa tiedostoa hosts.yml oman verkkoympäristösi mukaiseksi. Esimerkissä on laiteryhmä 's7home', johon kuuluu 1 laite nimeltä 'rivoriitta.s7'. Laitetta varten tarvitaan IP-osoite (kenttä 'ansible_host: 1.2.3.4') sekä muuttujat/vars (mm ssh-parametrit) tiedostossa group_vars/s7home.

Docker-palveluja varten tarvittavat asetukset ovat docker-kansion tiedostossa .env.