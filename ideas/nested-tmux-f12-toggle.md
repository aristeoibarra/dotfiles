# Nested Tmux: F12 Toggle para sesiones SSH

## Problema

Al conectarse por SSH desde una sesion tmux local a un servidor que tambien usa tmux,
ambas instancias comparten el mismo prefix (`Ctrl+b`). No hay forma de saber a cual
tmux van los comandos, lo que genera confusion y errores constantes.

Alternativas basicas:
- Salir del tmux local antes de SSH: pierdes contexto local
- Usar prefix diferente en remoto (`Ctrl+a`): hay que recordar dos prefixes
- Prefix doble (`Ctrl+b Ctrl+b`): incomodo y propenso a error

## Solucion: F12 Toggle

Presionar **F12** desactiva el tmux local — todas las teclas pasan directo al tmux
remoto. F12 de nuevo reactiva el local. Cambio visual en la status bar para saber
en que modo estas.

```
F12 ON  -> tmux local OFF, teclas van al remoto (status bar gris/apagado)
F12 OFF -> tmux local ON, comportamiento normal (status bar con colores)
```

## Implementacion

Agregar en `tmux/.tmux.conf`:

```tmux
# Nested tmux: F12 desactiva el tmux local para pasar keys al remoto
bind -T root F12 \
  set prefix None \;\
  set key-table off \;\
  set status-style "bg=colour238,fg=colour246" \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S

bind -T off F12 \
  set -u prefix \;\
  set -u key-table \;\
  set -u status-style \;\
  refresh-client -S
```

## Consideraciones

- El status-style en modo "off" deberia ser visualmente distinto al tema activo
  para que sea obvio que el tmux local esta desactivado
- Integrar con el sistema de temas (`bin/theme`) para que el color "off" se
  adapte al tema actual
- Funciona con cualquier nivel de anidacion (local -> bastion -> servidor)
- Mismo prefix en todas las maquinas, sin conflicto
