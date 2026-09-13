#!/bin/bash
echo "🔍 HARNESS PH - Verificando..."
terraform fmt -check
terraform validate
terraform plan -detailed-exitcode
EXIT=$?
if [ $EXIT -eq 0 ]; then echo "✅ No changes - estado puro"; fi
if [ $EXIT -eq 2 ]; then echo "📦 Mudanças pendentes"; fi
