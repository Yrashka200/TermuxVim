#!/bin/bash
pkg install -y openjdk-17 gradle maven
pkg install -y jdtls
echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"' >>"$HOME/.bashrc"
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >>"$HOME/.bashrc"
