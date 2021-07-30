# keiko/config.mk

HOST := $(shell uname -s)-$(shell uname -m)

CC-Linux-x86_64 = gcc

DEF-Linux-x86_64 = -DM64X32

_CC := $(CC-$(HOST))
HOST_DEFINES = $(DEF-$(HOST))

ifndef _CC
    $(error Can't configure for host type $(HOST))
endif

CC = $(_CC) -std=gnu99
