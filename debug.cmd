@docker run --rm -d -p 8080:80 --name nagios dcjulian29/nagios
@docker exec -it nagios bash
@docker stop nagios
