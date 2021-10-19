# Arjen Johtamisratkaisujen Alusta, ARJA
## Käyttöönotto:
1. Lataa tämä repo koneelle, josta voit ajaa ansible-playbook:eja
2. Perusta ubuntu/debian-kohdekone ja avaa sille SSH
3. Päivitä hosts.yml tiedosto uuden etäkoneen tiedoilla
4. Aja ansible-playbook-komento site.yml

## Tuottaa:
- docker-imaget kullekin konttipalvelulla (19LOK21: nginx ja flask-app)
- docker-kontit
- flask-appia voi testata selaimella portista 8080