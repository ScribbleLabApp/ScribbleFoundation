#! /bin/bash
swift package --allow-writing-to-directory ./ \
    generate-documentation --target ScribbleFoundation \
    --disable-indexing \
    --transform-for-static-hosting \
    --experimental-enable-custom-templates \
    --hosting-base-path / \
    --output-path ./Build \