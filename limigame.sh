# Configuração do Tabuleiro
WIDTH=20
HEIGHT=10

px=5
py=5

tx=$((RANDOM % (WIDTH - 2) + 1))
ty=$((RANDOM % (HEIGHT - 2) + 1))

score=0

# Configura o terminal para ler teclas sem precisar de Enter
stty -echo -icanon

clear
echo "=== MINI-JOGO PORTÁTIL UCRT64 ==="
echo "Usa as SETAS do teclado para apanhar o \$!"
echo "Carrega em 'q' para sair."
sleep 2

while true; do
    clear
    echo "Pontuação: $score | Sair: q"
    
    y=0
    while [ $y -lt HEIGHT ] 2>/dev/null || [ $y -lt $HEIGHT ]; do
        # Desenho do tabuleiro (mantém igual)
        x=0
        line=""
        while [ $x -lt $WIDTH ]; do
            if [ $x -eq 0 ] || [ $x -eq $((WIDTH - 1)) ] || [ $y -eq 0 ] || [ $y -eq $((HEIGHT - 1)) ]; then
                line="${line}#"
            elif [ $x -eq $px ] && [ $y -eq $py ]; then
                line="${line}O"
            elif [ $x -eq $tx ] && [ $y -eq $ty ]; then
                line="${line}\$"
            else
                line="${line} "
            fi
            x=$((x + 1))
        done
        echo "$line"
        y=$((y + 1))
    done

    # Lê apenas 1 caractere sem bloquear o script indefinidamente
    read -n 1 key

    if [ "$key" = "q" ]; then
        break
    fi

    # Como as setas no Windows enviam códigos ANSI de múltiplos caracteres (começam por ESC),
    # se detetarmos um caractere vazio ou especial, lemos o resto rapidamente:
    if [ "$key" = "" ]; then
        read -n 2 -t 0.01 extra
        key="$extra"
    fi

    case "$key" in
        "A") [ $py -gt 1 ] && py=$((py - 1)) ;; # Cima
        "B") [ $py -lt $((HEIGHT - 2)) ] && py=$((py + 1)) ;; # Baixo
        "C") [ $px -lt $((WIDTH - 2)) ] && px=$((px + 1)) ;; # Direita
        "D") [ $px -gt 1 ] && px=$((px - 1)) ;; # Esquerda
    esac

    if [ $px -eq $tx ] && [ $py -eq $ty ]; then
        score=$((score + 1))
        tx=$((RANDOM % (WIDTH - 2) + 1))
        ty=$((RANDOM % (HEIGHT - 2) + 1))
    fi

    # Pequena pausa para o jogo não correr a 1000 frames por segundo
    sleep 0.05
done

stty sane
clear
echo "Jogo terminado! Pontuação final: $score"
