docker swarm init --advertise-addr 192.168.255.134

docker swarm join --token SWMTKN-1-3xpmybq9tqznq5enoxn7sj92k2fvy0qbhqsi9dl01k805jk4sr-5jl8c87g4aahfvfke18kzvrt2 192.168.255.134:2377

docker network create --driver overlay wtel --attachable
1323qfvt8f4ck0b3ulppg56xn

docker node list
docker node update --label-add type=primary m2lcp9er43lyyx58xxhjb8gx4
docker node update --label-add type=secondary kuf157r47xwnv9mvlle1br1m4

