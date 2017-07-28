#!/usr/local/bin/python
# encoding=utf8
import requests
from bs4 import BeautifulSoup
import os, json
import base64
from Crypto.Cipher import AES
from prettytable import PrettyTable
import warnings
import re
import uuid

warnings.filterwarnings("ignore")
_session = requests.session()

#TOP500 目前页面只能爬取22首
TOP500_URL = 'http://www.kugou.com/yy/rank/home/1-8888.html?from=rank'
#华语新歌榜
HUAYU_NEWSONG_URL = "http://www.kugou.com/yy/rank/home/1-27.html?from=rank"
#欧美新歌榜
OUMEI_NEWSONG_URL = "http://www.kugou.com/yy/rank/home/1-28.html?from=rank"
#中国新声榜
XINGESHENG_URL = "http://www.kugou.com/yy/rank/home/1-30681.html?from=rank"

REPLACE_URL = 'http://www.kugou.com/yy/index.php?r=play/getdata&'

plistFile = open('DemoSongs.plist','w+')

class Song(object):
    def __lt__(self, other):
        return self.commentCount > other.commentCount

def writeToPlist(songInfoList):
    #timeLength,fileSize,albumName,imgUrl,audioName,singerName,songUrl
    timeLength = songInfoList[0].split(':')[1]
    fileSize = songInfoList[1]
    albumName = songInfoList[2].decode("unicode-escape")
    imgUrl = songInfoList[3].decode("unicode-escape")
    imgUrl = imgUrl.replace('\\','')
    imgUrl = imgUrl.split('\"img\":')
    if len(imgUrl) < 2:
        return
    imgUrl = imgUrl[1].strip('\"')
    if len(imgUrl) < 1:
        return
    audioName = songInfoList[4].decode("unicode-escape")
    audioName = audioName.split(':')[1].strip('\"') 
    singerName = songInfoList[5].decode("unicode-escape")
    singerName = singerName.split(':')[1].strip('\"') 
    singerName = singerName.replace('&','')
    songUrl = songInfoList[6].decode("unicode-escape")
    print songUrl
    songUrl = songUrl.replace('\\','')
    songUrl = songUrl.split('\"play_url\":')
    if len(songUrl) < 2:
        return
    songUrl = songUrl[1].strip('\"')
    if len(songUrl) < 1:
        return
    print timeLength,fileSize,albumName,imgUrl,audioName,singerName,songUrl
    lines = ["<dict>\n"]
    lines.append("<key>duration</key>\n")
    lines.append("<string>")
    lines.append(timeLength)
    lines.append("</string>\n")
    lines.append("<key>albumUrl</key>\n")
    lines.append("<string>")
    lines.append(imgUrl)
    lines.append("</string>\n")
    lines.append("<key>songUrl</key>\n")
    lines.append("<string>")
    lines.append(songUrl)
    lines.append("</string>\n")
    lines.append("<key>singer</key>\n")
    lines.append("<string>")
    lines.append(singerName.encode('utf-8'))
    lines.append("</string>\n")
    lines.append("<key>songId</key>\n")
    lines.append("<string>")
    lines.append(str(uuid.uuid1()))
    lines.append("</string>\n")
    lines.append("<key>songName</key>\n")
    lines.append("<string>")
    lines.append(audioName.encode('utf-8'))
    lines.append("</string>\n")
    lines.append("</dict>\n")

    #print lines
    plistFile.writelines(lines)
    
    
def writePlistHeader():
    lines = ["<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"] 
    lines.append("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n")
    lines.append("<plist version=\"1.0\">\n")
    lines.append("<array>\n")
    plistFile.writelines(lines)

def writePlistFooter():
    lines = ["</array>\n"]
    lines.append("</plist>")
    plistFile.writelines(lines)
    
     
#根据歌曲URL找到hash值并构建新的请求URL 返回真正的歌曲信息
def getSongInfo(songUrl):
    detailSoup = BeautifulSoup(_session.get(songUrl).content)
    #print detailSoup
    pattern = re.compile(r'(.*) dataFromSmarty (.*?) .*') 
    script = detailSoup.find('script',text=pattern)
    #print script
    value = pattern.search(script.text).group().split('[{')
    value = value[1].split('}]')
    value = value[0].split(',')
    hashValue = value[0]
    hashValue = hashValue.split(':')
    hashValue = hashValue[1].strip('\"')
    realUrl = "http://www.kugou.com/yy/index.php?r=play/getdata&hash=" + hashValue 
    #print realUrl 
    realSoup = BeautifulSoup(_session.get(realUrl).content)
    #print realSoup
    jsonData = realSoup.p.get_text()
    jsonData = jsonData.split('\"data\":')[1]
    jsonData = jsonData.split(',')
    #print jsonData
    timeLength = jsonData[1]
    fileSize = jsonData[2]
    albumName = jsonData[5]
    imgUrl = jsonData[7]
    singerName = jsonData[10]
    audioName = jsonData[11]
    songUrl = jsonData[16]
    return [timeLength,fileSize,albumName,imgUrl,audioName,singerName,songUrl]

def getSongs(url):
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36'}
    url.decode('utf-8')
    r = requests.get(url,headers=headers)
    soup = BeautifulSoup(r.text,'html')
    #print soup
    div = soup.find('div', attrs={'class': 'pc_temp_songlist'})
    list = div.ul.findAll('li')
    #print list
    for li in list:
        songUrl = li.a['href'] 
        songUrl.decode('utf-8')
        #print songUrl
        songInfo = getSongInfo(songUrl)
        writeToPlist(songInfo)	

def main():
    writePlistHeader()
    getSongs(TOP500_URL)
    getSongs(HUAYU_NEWSONG_URL)
    getSongs(OUMEI_NEWSONG_URL)
    getSongs(XINGESHENG_URL)
    writePlistFooter()
    plistFile.close()
if __name__ == '__main__':
    main()
