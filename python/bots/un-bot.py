# un[bot]
# Developed by pswsm
# Based on BasuraBot from blai8 and myself
# Licensed under the GNU-General Public License

# libs #
import os

import discord, random, asyncio
from discord.ext import commands
from itertools import cycle
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')

# prefix
unBot = commands.Bot(command_prefix='<>')

@unBot.event
async def on_ready():
    print(f'Iniciat com a {unBot.user}')

#ordres
@unBot.command(name='ping', help='Tipica orden de ping.')
async def ping(ctx):
    await ctx.send(f'pong -- Latencia: {int(unBot.latency * 1000)}ms')

@unBot.command(name='unete', help='Se una al canal de voz.')
async def unete(ctx):
    canal = ctx.message.author.voice.voice_channel
    await ctx.send(f'Estas al canal {canal}')
    await unBot.join_voice_channel(canal)


unBot.run(TOKEN)
