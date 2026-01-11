-- Vim Cheatsheet: Native commands for programmers
local M = {}

local cheatsheet_content = [[
================================================================================
                    VIM CHEATSHEET - COMANDOS PARA PROGRAMADORES
================================================================================

MOVIMIENTO BÁSICO
─────────────────
  h j k l           Izquierda, abajo, arriba, derecha
  Ctrl+u / Ctrl+d   Media página arriba/abajo
  Ctrl+b / Ctrl+f   Página completa arriba/abajo
  gg / G            Inicio/fin del archivo
  {número}G         Ir a línea específica (ej: 42G)
  0 / $             Inicio/fin de línea
  ^                 Primer carácter no blanco de línea
  %                 Ir al paréntesis/llave/corchete que hace match

MOVIMIENTO POR PALABRAS
────────────────────────
  w / W             Siguiente palabra (word/WORD)
  b / B             Palabra anterior (back)
  e / E             Fin de palabra (end)
  ge / gE           Fin de palabra anterior

  Nota: word - delimitado por espacios/puntuación
        WORD - delimitado solo por espacios

BÚSQUEDA Y NAVEGACIÓN
─────────────────────
  f{char}           Buscar carácter adelante en línea
  F{char}           Buscar carácter atrás en línea
  t{char}           Hasta carácter (before)
  T{char}           Hasta carácter atrás
  ; / ,             Repetir búsqueda f/t adelante/atrás
  * / #             Buscar palabra bajo cursor adelante/atrás
  n / N             Siguiente/anterior resultado de búsqueda
  /{patrón}         Buscar patrón adelante
  ?{patrón}         Buscar patrón atrás

EDICIÓN BÁSICA
──────────────
  i / I             Insert mode (en cursor / inicio de línea)
  a / A             Append (después cursor / fin de línea)
  o / O             Nueva línea abajo/arriba y entrar insert mode
  s / S             Substitute (carácter / línea completa)
  r{char}           Reemplazar carácter bajo cursor
  x / X             Delete carácter (bajo cursor / antes cursor)
  dd                Borrar línea
  yy                Copiar línea (yank)
  p / P             Pegar después/antes del cursor
  u                 Undo
  Ctrl+r            Redo
  .                 Repetir último cambio

TEXT OBJECTS (SUPER ÚTIL PARA PROGRAMADORES)
─────────────────────────────────────────────
Estructura: {operador}{a/i}{objeto}
  - operadores: c (change), d (delete), y (yank), v (visual)
  - a: around (incluye delimitadores)
  - i: inner (sin delimitadores)

  ciw / diw / yiw   Change/delete/yank inner word
  caw / daw / yaw   Change/delete/yank around word
  ci" / di" / yi"   Change/delete/yank inside quotes
  ca" / da" / ya"   Change/delete/yank around quotes
  ci( / ci) / cib   Change inside parentheses
  ci[ / ci]         Change inside brackets
  ci{ / ci} / ciB   Change inside braces
  cit               Change inside tag (HTML/XML)
  cip / dip         Change/delete inside paragraph
  cas / das         Change/delete around sentence

  Ejemplos prácticos:
    ciw    en "hello|world"  → cambiar "world"
    di(    en "foo(bar|baz)" → borrar "barbaz"
    ca{    en "{|code}"      → borrar incluyendo las llaves
    vit    en "<p>|text</p>" → seleccionar "text"

OPERADORES + MOVIMIENTOS (COMPONER COMANDOS)
─────────────────────────────────────────────
  d{movimiento}     Delete hasta movimiento
  c{movimiento}     Change hasta movimiento
  y{movimiento}     Yank hasta movimiento
  >{movimiento}     Indent
  <{movimiento}     Unindent

  Ejemplos:
    d2w              Borrar 2 palabras
    c$               Cambiar hasta fin de línea
    y3j              Copiar 3 líneas hacia abajo
    d/hello          Borrar hasta encontrar "hello"
    cG               Cambiar hasta fin de archivo
    ygg              Copiar desde inicio de archivo
    >ip              Indentar párrafo
    =ap              Auto-indentar párrafo

VISUAL MODE (SELECCIÓN)
───────────────────────
  v                 Visual character-wise
  V                 Visual line-wise
  Ctrl+v            Visual block-wise (columnas)
  o                 Ir al otro extremo de la selección
  O                 Ir a otra esquina (block mode)
  gv                Reseleccionar última selección visual
  aw / iw           Select a/inner word (en visual)
  ab / ib           Select a/inner block

  En Visual Block (Ctrl+v):
    I    Insert al inicio de cada línea
    A    Append al final de cada línea
    c    Change en todas las líneas

INDENTACIÓN Y FORMATO (ESENCIAL PARA CÓDIGO)
─────────────────────────────────────────────
  >> / <<           Indent/unindent línea
  >{ / <{           Indent/unindent hasta llave
  >ip / <ip         Indent/unindent párrafo
  =                 Auto-indent (smart)
  ==                Auto-indent línea actual
  ={movimiento}     Auto-indent hasta movimiento
  gg=G              Auto-indent TODO el archivo
  =ap               Auto-indent párrafo
  gq{movimiento}    Format text (wrap lines)
  gqq               Format línea actual
  J                 Join línea siguiente (sin espacios: gJ)

MAYÚSCULAS/MINÚSCULAS
─────────────────────
  ~                 Toggle case del carácter
  gU{movimiento}    Uppercase
  gu{movimiento}    Lowercase
  gUiw              Uppercase palabra
  guiw              Lowercase palabra
  gUU / guu         Uppercase/lowercase línea completa

MACROS (AUTOMATIZACIÓN)
───────────────────────
  q{letra}          Comenzar a grabar macro en registro {letra}
  q                 Parar grabación
  @{letra}          Ejecutar macro del registro {letra}
  @@                Repetir último macro ejecutado
  {número}@{letra}  Ejecutar macro N veces (ej: 10@a)

  Ejemplo de workflow:
    qa      → Empezar grabar en registro 'a'
    ...     → Hacer cambios
    q       → Parar
    @a      → Ejecutar una vez
    100@a   → Ejecutar 100 veces

MARKS Y JUMPS (NAVEGACIÓN AVANZADA)
────────────────────────────────────
  m{letra}          Crear mark (a-z: local, A-Z: global)
  '{letra}          Saltar a mark (inicio de línea)
  `{letra}          Saltar a mark (posición exacta)
  ''                Volver a posición anterior (línea)
  ``                Volver a posición anterior (exacta)
  Ctrl+o            Saltar atrás en jump list
  Ctrl+i            Saltar adelante en jump list
  '.                Ir a última modificación
  '"                Ir a posición donde cerró archivo

  Marks especiales:
    `.    Última modificación
    `"    Última posición al cerrar
    `[    Inicio de último cambio/yank
    `]    Fin de último cambio/yank

REGISTERS (PORTAPAPELES MÚLTIPLES)
──────────────────────────────────
  "{registro}       Usar registro específico
  "ayy              Copiar línea al registro 'a'
  "ap               Pegar desde registro 'a'
  "+y               Copiar al clipboard del sistema
  "+p               Pegar desde clipboard del sistema
  :reg              Ver contenido de todos los registros

  Registros especiales:
    "    Unnamed (último delete/yank)
    0    Último yank
    +    Clipboard del sistema
    *    Selection (X11)
    /    Última búsqueda
    :    Último comando

NÚMEROS Y REPETICIÓN
────────────────────
  {número}{comando} Repetir comando N veces
  5j                Bajar 5 líneas
  3dd               Borrar 3 líneas
  10w               Avanzar 10 palabras
  2ciw              Cambiar 2 palabras

BÚSQUEDA Y REEMPLAZO
────────────────────
  :%s/old/new/g     Reemplazar en todo el archivo
  :s/old/new/g      Reemplazar en línea actual
  :'<,'>s/old/new/g Reemplazar en selección visual
  :%s/old/new/gc    Reemplazar con confirmación
  :g/pattern/d      Borrar líneas que hagan match
  :v/pattern/d      Borrar líneas que NO hagan match

VENTANAS Y BUFFERS
──────────────────
  Ctrl+w s          Split horizontal
  Ctrl+w v          Split vertical
  Ctrl+w h/j/k/l    Navegar entre ventanas
  Ctrl+w w          Siguiente ventana
  Ctrl+w c          Cerrar ventana
  Ctrl+w o          Cerrar todas menos actual
  Ctrl+w =          Igualar tamaño ventanas
  :bn / :bp         Next/previous buffer
  :bd               Cerrar buffer

COMANDOS ÚTILES PARA CÓDIGO
────────────────────────────
  [ [               Ir a función anterior
  ] ]               Ir a siguiente función
  [ {               Ir a { anterior
  ] }               Ir a } siguiente
  gd                Go to definition (local)
  gD                Go to definition (global)
  K                 Buscar ayuda de palabra (LSP override)

MODO COMANDO RÁPIDO
───────────────────
  :w                Guardar
  :q                Salir
  :wq / :x / ZZ     Guardar y salir
  :q! / ZQ          Salir sin guardar
  :e archivo        Editar archivo
  :!comando         Ejecutar comando shell
  :.!comando        Filtrar línea por comando
  :%!comando        Filtrar archivo por comando

TIPS PRO
────────
  .                 Repetir último cambio (EL MÁS PODEROSO)
  ;                 Repetir último f/F/t/T
  Ctrl+a / Ctrl+x   Incrementar/decrementar número
  :earlier 5m       Volver 5 minutos atrás en historial
  :later 2m         Avanzar 2 minutos en historial

================================================================================
Presiona 'q' o 'Esc' para cerrar | Busca con '/' | Navega con j/k
================================================================================
]]

local buf = nil
local win = nil

function M.toggle()
  -- Si ya está abierto, cerrarlo
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
    buf = nil
    return
  end

  -- Crear buffer si no existe
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(cheatsheet_content, "\n"))
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].filetype = "cheatsheet"

    -- Keymaps para cerrar
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
  end

  -- Calcular tamaño de ventana flotante
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Crear ventana flotante
  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Vim Cheatsheet ",
    title_pos = "center",
  })

  -- Opciones de ventana
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true
end

return M
