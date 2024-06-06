from pythonosc import osc_message_builder
from pythonosc import osc_bundle_builder
from pythonosc import udp_client
# Dirección IP y puerto donde se ejecuta el programa de Processing
HOST = '127.0.0.1'  # Dirección IP de la máquina local
PORT = 2222  # Puerto en el que el programa de Processing escucha

client = udp_client.SimpleUDPClient("127.0.0.1", 12001)

def sendOsc(message, client):
    msg = osc_message_builder.OscMessageBuilder(address = "/adress")
    msg.add_arg(message)
    msg = msg.build()
    client.send(msg)

# Llama a la función para enviar datos
sendOsc("clase2", client)  # Cambia esto por los datos que deseas enviar
