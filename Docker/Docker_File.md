## Dockerfile nedir

Dockerfile, belli bir image goruntusu olusturmak icin var olan tum katmanlarin madde made
aciklandiği ve tum islemlerin detaylica belirtildigi text dosyalaridir.

Dockerfile text dosyalari "YAML" adi verilen insan tarafindan kolayca okunabilen bir dil kullanilarak yazilmaktadir.

https://docs.docker.com/engine/reference/builder

## FROM

Hangi image dosyanin referans alinacagi belirtilir

FROM <image>:tag

FROM python:2.7

FROM centos:lates

FROM microsoft/iis:nanoserver

FROM mcr.microsoft.com/dotnet/framework/aspnet:latest

FROM mcr.microsoft.com/windows/servercore:1607

FROM mcr.microsoft.com/windows/servercore:1703


