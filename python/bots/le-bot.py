#basura[bot]
#Developed by Blai Vilarnau & Pau Figueras
#Licensed under the GNU-General Public License.
##################LIBS#################

import discord
import random
from discord.ext import commands, tasks
from itertools import cycle

#################PREFIX################

client = commands.Bot(command_prefix = "|")

###########VARIABLES GLOBALS###########

status = cycle(["Ouuuh yeah, diamantes....", "De lunes a domingo voy todo viciado,", "La antorcha prendida, luz por todos los lados.", "Picando y picando y yo no te he encontrado", "Las manecillas giran, ya hay zombies sonando", "Bajandome la vida y no voy ni armado", "Bebiendome la leche a sorbos y a tragos", "te vi asi de frente que tremendo impacto,", "pa picarte un poquito dime", "Si hay que ser minero,", "romper el pico en el hierro", "no importa el creeper que venga pa' que sepas que te quiero", "como un buen minero, me juego la vida por tiiiiii.", "Y te cuentan que ya me vieron solitario en la habitacion", "que ya no duermo y desvario", "que a las gallinas no les doy amor.", "Y tu por donde estas?", "Que la presion me va a matar", "Te picare vuelve conmigo,", "Y QUE TU NO SABES", "Que yo te necesito como el horno al coal", "Diamante si yo te encuentro yo te pico to'a", "Te vi asi de frente que tremendo impacto,", "pa picarte un poquito dime", "Si hay que ser minero,", "romper el pico en el hierro", "no importa el creeper que venga pa' que sepas que te quiero", "como un buen minero, me juego la vida por tiiiiii.", "Y de la nieve al desierto, si que te necesito", "Y de la jungla a los prados, quiero que estes conmigo", "Y bajo tierra mi amor,", "en el agua tu y yo.", "No importa mi amada,", "Si hay, Si hay que ser minero ", "romper el pico en el hierro", "no importa el creeper que venga pa' que sepas que te quiero", "como un buen minero, me juego la vida por tiiiiii.", "BIBA EL RUBIUH"])

annaSleep = 9

niceNum = ["69", "422", "420", "777", "1312", "666", "80085", "1337"]

##############FUNCIONS##################
def isNice(n):
    if n in niceNum:
        return True
    else:
        return False

#def isNice(n):
#   niceNum = [69, 422, 420, 777, 1312, 666, 80085, 1337]
#

#################EVENTS#################
#BotStartup
@client.event
async def on_ready():
    change_status.start()
    print("bitch lasagna")

#MemberJoin log
@client.event
async def on_member_join(member):
    print(f"{member} ha comès l'error d'entrar al servidor.")

#MemberRemove Log
@client.event
async def on_member_remove(member):
    print(f"{member} ha escapat amb vida del servidor. GG WP.")

###############TASKS######################
#Status
@tasks.loop(seconds=5)
async def change_status():
    await client.change_presence(activity=discord.Game(next(status)))

###################COMMANDS###############
#Helloworld
@client.command()
async def hw(ctx):
    await ctx.send("Helloworld")

#Ping
@client.command()
async def ping(ctx):
    await ctx.send(f"Pong! ({int(client.latency * 1000)}ms)")

#Ruleta Russa
@client.command()
async def shoot(ctx, chamber):
    shoot = random.randint(1,6)
    cowboy = ctx.author
    if (int(chamber) <= 0) or (int(chamber) >= 7):
        await ctx.send("There are only 6 chambers. Therfore you need to say a number between 1 and 6")
    elif shoot == int(chamber):
        await ctx.send(f"{cowboy} died. GGWP. They fired chamber {chamber}, and the bulled was sadly there")
        await cowboy.kick(reason = "unlucky")
    elif shoot != int(chamber):
        await ctx.send(f"{cowboy} is somehow alive. They fired chamber {chamber}, but the bullet was at {shoot}")
    else:
        await ctx.send("Error")

#Kick
@client.command()
@commands.has_permissions(administrator=True)
async def kick(ctx, member : discord.Member, *, reason=None):
    await member.kick(reason=reason)
    if reason != None:
        await ctx.send(f"{ctx.author} ha expulsat a {member} amb la raó: {reason}")
        print(f"{ctx.author} ha expulsat a {member} amb la raó: {reason}")
    elif reason == None:
        await ctx.send(f"{ctx.author} ha expulsat a {member}")
        print(f"{ctx.author} ha expulsat a {member}")

#Ban
@client.command()
@commands.has_permissions(administrator=True)
async def ban(ctx, member : discord.Member, *, reason=None):
    await member.ban(reason=reason)
    if reason != None:
        await ctx.send(f"{ctx.author} ha expulsat permanentment a {member} amb la raó: {reason}")
        print(f"{ctx.author} ha expulsat permanentment a {member} amb la raó: {reason}")
    elif reason == None:
        await ctx.send(f"{ctx.author} ha expulsat permanentment a {member}")
        print(f"{ctx.author} ha expulsat permanentment a {member}")

#Clear
@client.command()
@commands.has_permissions(administrator=True)
async def clear(ctx, amount=1):
    print(ctx.author, "has cleared", amount, "messages" )
    await ctx.channel.purge(limit=amount+1)

#8ball
@client.command(aliases=["8ball"])
async def _8ball(ctx, *, question):
    responses = ["Pos si", "Pos no", "El pare de la Martina", "PERDONA?!?!?!", "Encara que sembli impossible, jo diria que si", "D1 tt", "Tinc cara de que m'importi?", "Realment no en tinc ni idea", "Això m'ho tornes a preguntar quan porti un morat enorme, vale?", "La teva pregunta me la sua, només vinc a recordar que el pare de la Martina podria arribar a tenir polls", "Això està escrit el 8/4/2020 a les 2:52am", "Podria ser, però només si el penis del Bernat ho vol així", "Si tu vols", "La resposta està a l'interior del pare de la Martina", "Ni parlar-ne", "Que esperes? CARPE DIEM", "Error 404", "ABDUSCAN", "Llibertat Presos Politics","Vaya basura de persona", "Ya ves tio, que peruANO", "Depen del que Hitler vulgui", "L'hi acabo de consultar al Donlad Trump i ell diu que no", "Tu decideixes, truco a l'FBI o a ta mare? (o al pare de la Martina)", "Això és una pregunta estúpida", "Te lo dice el chico fitness, el chico que nació antes que su madre", "La vida és dura, pero mas dura és mi musculatura", "NO TE HAGAS LA VISTIMA", "Ho-ho-hola", "no, mejor no :(", "BAS TA", "QUIERO QUE TODOS HAGAMOS PALMAS", "Que asco de vida", "La martina i la anna us estiman <3", "blai te queremos dentro del país, era una broma ya te puedes ir", "pau deixa de menjar gossos ya", "te lo dise el chico fitness", "la vida és dura pero más dura es mi musculatura", f"L'Anna s'ha adormit en trucada {annaSleep} vegades"]
    resposta = random.choice(responses)
    if question == "Quantes vegades s'ha adormit l'Anna en trucada?":
        await ctx.send(f"L'Anna s'ha adormit en trucada {annaSleep} vegades")
    elif question == "items":
        await ctx.send(f"Actualment hi ha {len(responses)} respostes diferents")
    else:
        await ctx.send(f"Pregunta: {question}\nResposta: {resposta}")

#Say
@client.command()
async def say(ctx, *, text):
    print("say author:", ctx.author, "Message:", text)
    await ctx.send(f"{text}")

#Sayd
@client.command()
async def sayd(ctx, *, text):
    print("sayd author:", ctx.author, "Message:", text)
    await ctx.channel.purge(limit=1)
    await ctx.send(f"{text}")

#Anna feka
@client.command()
async def anna(ctx, *, remain):
    await ctx.send(f"L'Anna s'ha adormit en trucada {annaSleep} vegades i comptant")

#Nice
@client.command()
async def nice(ctx, num):
    if isNice(num) == True:
        await ctx.send(f"El número {num} és Nice!!!")
    else:
        await ctx.send(f"El número {num} no és nice D:")

#Nice v2
@client.command()
async def nicev2(ctx, n):
    if n in niceNum:
        await ctx.send(f"El número {n} és Nice!!")
    else:
        await ctx.send(f"El número {n} no és nice... :<")

@client.command(pass_context=True)
async def rol(ctx, *, nickname):
    await client.change_nickname(ctx.message.author, nickname)
    role = get(ctx.message.server.roles, name='ARMA_ROLE') # Replace ARMA_ROLE as appropriate
    if role: # If get could find the role
        await client.add_role(ctx.message.author, role)

###################TOKEN###################

client.run("")

###########################################
