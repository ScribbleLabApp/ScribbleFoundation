#!/bin/bash

#  Copyright (c) 2015 - 2024 Apple Inc. - All rights reserved.
#  Copyright (c) 2024 ScribbleLabApp LLC.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#
#  1. Redistributions of source code must retain the above copyright notice, this
#     list of conditions and the following disclaimer.
#
#  2. Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
#  3. Neither the name of the copyright holder nor the names of its
#     contributors may be used to endorse or promote products derived from
#     this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

read -p "This will replace your current pasteboard. Continue? [y/n]" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    swiftversion=$(swift --version)
    unix_version_name=$(uname -a | tr ";" '\n')
    i="${i}Swift version: ${swiftversion}\n"
    i="${i}Unix version: ${unix_version_name}\n"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        macos=$(defaults read loginwindow SystemVersionStampAsString | cat -)
        xcodebuild_version=$(/usr/bin/xcodebuild -version | grep Xcode)
        xcodebuild_build=$(/usr/bin/xcodebuild -version | grep Build)
        xcodeselectpath=$(xcode-select -p | cat -)
    
        i="${i}\nmacOS version: ${macos}\n"
        i="${i}Xcode-select path: '${xcodeselectpath}\n"
        i="${i}Xcode: ${xcodebuild_version} (${xcodebuild_build})"
    fi

    echo -e "${i}" | pbcopy
    echo "Your pasteboard now contains debug info, paste it on Github"
fi
