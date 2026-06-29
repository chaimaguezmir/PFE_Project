$components = @(
  @{
    File='01_utilisateurs'
    Title='Utilisateurs'
    Subtitle='Patients + professionnels'
    Color1='#12a7c7'; Color2='#173a73'
    Icon='users'
  },
  @{
    File='02_application_mobile_flutter'
    Title='Application mobile'
    Subtitle='Flutter / Android'
    Color1='#18b6d4'; Color2='#0b5d9c'
    Icon='phone'
  },
  @{
    File='03_application_scanner'
    Title='Application scanner'
    Subtitle='Scan code-barres'
    Color1='#16a085'; Color2='#0f766e'
    Icon='scanner'
  },
  @{
    File='04_backoffice_web'
    Title='Back-office web'
    Subtitle='React + Vite / Port 5174'
    Color1='#7357e8'; Color2='#352180'
    Icon='browser'
  },
  @{
    File='05_backend_spring_boot'
    Title='Serveur applicatif'
    Subtitle='Spring Boot API / Port 8081'
    Color1='#31b057'; Color2='#176b36'
    Icon='server'
  },
  @{
    File='06_base_donnees_mysql'
    Title='Base de données'
    Subtitle='MySQL / Port 3306'
    Color1='#2d7ecb'; Color2='#123c69'
    Icon='database'
  },
  @{
    File='07_stockage_fichiers'
    Title='Stockage fichiers'
    Subtitle='Ordonnances PDF + logs'
    Color1='#f2a93b'; Color2='#b86608'
    Icon='folder'
  },
  @{
    File='08_firebase_fcm'
    Title='Firebase FCM'
    Subtitle='Notifications push'
    Color1='#ffca28'; Color2='#f57c00'
    Icon='bell'
  },
  @{
    File='09_smtp_gmail'
    Title='SMTP Gmail'
    Subtitle='Emails activation'
    Color1='#ea4335'; Color2='#b3261e'
    Icon='mail'
  },
  @{
    File='10_openfda'
    Title='OpenFDA'
    Subtitle='Données médicaments'
    Color1='#0097a7'; Color2='#005f73'
    Icon='pill'
  },
  @{
    File='11_groq_llm'
    Title='Groq / LLM'
    Subtitle='Assistant IA'
    Color1='#b31349'; Color2='#5f1230'
    Icon='brain'
  },
  @{
    File='12_openstreetmap'
    Title='OpenStreetMap'
    Subtitle='Géolocalisation'
    Color1='#42b883'; Color2='#1b7f5a'
    Icon='map'
  }
)

New-Item -ItemType Directory -Force -Path $PSScriptRoot | Out-Null

function Get-Icon($name) {
  switch ($name) {
    'users' { return @'
      <circle cx="242" cy="176" r="46" fill="#ffffff"/>
      <path d="M152 350c10-72 62-124 124-124s114 52 124 124c3 21-13 40-34 40H186c-21 0-37-19-34-40z" fill="#ffffff"/>
      <circle cx="148" cy="208" r="36" fill="#ffffff" opacity="0.82"/>
      <path d="M82 368c8-54 46-94 92-98c-22 26-38 58-45 95c-2 10-1 19 2 28H112c-19 0-33-17-30-35z" fill="#ffffff" opacity="0.82"/>
      <circle cx="390" cy="208" r="36" fill="#ffffff" opacity="0.82"/>
      <path d="M428 393h-19c3-9 4-18 2-28c-7-37-23-69-45-95c46 4 84 44 92 98c3 18-11 35-30 35z" fill="#ffffff" opacity="0.82"/>
'@ }
    'phone' { return @'
      <rect x="190" y="98" width="164" height="292" rx="32" fill="#ffffff"/>
      <rect x="214" y="134" width="116" height="198" rx="12" fill="#e9f7fb"/>
      <circle cx="272" cy="360" r="10" fill="#173a73"/>
      <path d="M238 210h68M238 246h68M238 282h44" stroke="#173a73" stroke-width="14" stroke-linecap="round"/>
'@ }
    'scanner' { return @'
      <path d="M132 148V98h70M342 98h70v50M412 322v50h-70M202 372h-70v-50" fill="none" stroke="#ffffff" stroke-width="20" stroke-linecap="round"/>
      <rect x="170" y="170" width="204" height="132" rx="24" fill="#ffffff" opacity="0.96"/>
      <path d="M206 204h20v64h-20zM244 204h10v64h-10zM274 204h28v64h-28zM322 204h12v64h-12" fill="#173a73"/>
      <line x1="142" y1="236" x2="402" y2="236" stroke="#b31349" stroke-width="10" stroke-linecap="round"/>
'@ }
    'browser' { return @'
      <rect x="114" y="124" width="316" height="226" rx="24" fill="#ffffff"/>
      <rect x="114" y="124" width="316" height="54" rx="24" fill="#e8eff8"/>
      <circle cx="150" cy="151" r="8" fill="#ef4c86"/>
      <circle cx="178" cy="151" r="8" fill="#f2a93b"/>
      <circle cx="206" cy="151" r="8" fill="#42b883"/>
      <rect x="154" y="218" width="104" height="74" rx="14" fill="#7357e8" opacity="0.9"/>
      <path d="M286 226h80M286 260h62M286 294h92" stroke="#173a73" stroke-width="14" stroke-linecap="round"/>
'@ }
    'server' { return @'
      <rect x="154" y="98" width="236" height="92" rx="18" fill="#ffffff"/>
      <rect x="154" y="218" width="236" height="92" rx="18" fill="#ffffff"/>
      <rect x="154" y="338" width="236" height="92" rx="18" fill="#ffffff"/>
      <circle cx="190" cy="144" r="12" fill="#31b057"/>
      <circle cx="190" cy="264" r="12" fill="#31b057"/>
      <circle cx="190" cy="384" r="12" fill="#31b057"/>
      <path d="M224 144h116M224 264h116M224 384h116" stroke="#173a73" stroke-width="14" stroke-linecap="round"/>
'@ }
    'database' { return @'
      <ellipse cx="272" cy="128" rx="126" ry="52" fill="#ffffff"/>
      <path d="M146 128v204c0 29 56 52 126 52s126-23 126-52V128" fill="#ffffff"/>
      <path d="M146 196c0 29 56 52 126 52s126-23 126-52M146 264c0 29 56 52 126 52s126-23 126-52M146 332c0 29 56 52 126 52s126-23 126-52" fill="none" stroke="#173a73" stroke-width="10" opacity="0.35"/>
'@ }
    'folder' { return @'
      <path d="M112 164c0-24 19-44 44-44h92l34 42h118c24 0 44 20 44 44v184c0 25-20 44-44 44H156c-25 0-44-19-44-44z" fill="#ffffff"/>
      <path d="M112 218h332v172c0 25-20 44-44 44H156c-25 0-44-19-44-44z" fill="#fff4df"/>
      <path d="M196 286h150M196 328h112" stroke="#b86608" stroke-width="16" stroke-linecap="round"/>
'@ }
    'bell' { return @'
      <path d="M272 396c32 0 58-22 64-52H208c6 30 32 52 64 52z" fill="#ffffff"/>
      <path d="M158 328h228c-26-26-34-58-34-108c0-45-31-83-72-93v-15c0-15-12-28-28-28s-28 13-28 28v15c-41 10-72 48-72 93c0 50-8 82-34 108z" fill="#ffffff"/>
      <path d="M194 332h156" stroke="#173a73" stroke-width="14" stroke-linecap="round" opacity="0.35"/>
'@ }
    'mail' { return @'
      <rect x="112" y="150" width="320" height="224" rx="30" fill="#ffffff"/>
      <path d="M128 178l144 118l144-118" fill="none" stroke="#ea4335" stroke-width="20" stroke-linecap="round" stroke-linejoin="round"/>
      <path d="M132 352l104-92M412 352l-104-92" fill="none" stroke="#173a73" stroke-width="16" stroke-linecap="round" opacity="0.55"/>
'@ }
    'pill' { return @'
      <rect x="132" y="190" width="280" height="132" rx="66" fill="#ffffff" transform="rotate(-35 272 256)"/>
      <path d="M232 189l80 112" stroke="#0097a7" stroke-width="20" stroke-linecap="round"/>
      <circle cx="176" cy="352" r="22" fill="#ffffff"/>
      <circle cx="374" cy="150" r="18" fill="#ffffff" opacity="0.8"/>
'@ }
    'brain' { return @'
      <path d="M226 130c-46 0-84 36-84 82c0 7 1 14 3 21c-27 14-45 42-45 74c0 46 37 84 84 84h176c47 0 84-38 84-84c0-32-18-60-45-74c2-7 3-14 3-21c0-46-38-82-84-82c-18 0-35 6-48 16c-13-10-30-16-44-16z" fill="#ffffff"/>
      <path d="M214 190v144M272 166v190M330 196v138M172 264h200" stroke="#b31349" stroke-width="13" stroke-linecap="round" opacity="0.78"/>
'@ }
    'map' { return @'
      <path d="M272 96c-70 0-126 56-126 126c0 94 126 222 126 222s126-128 126-222c0-70-56-126-126-126z" fill="#ffffff"/>
      <circle cx="272" cy="222" r="48" fill="#42b883"/>
      <path d="M176 394l-64 36M368 394l64 36" stroke="#ffffff" stroke-width="18" stroke-linecap="round" opacity="0.75"/>
'@ }
  }
}

foreach ($c in $components) {
  $icon = Get-Icon $c.Icon
  $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" width="720" height="560" viewBox="0 0 720 560">
  <defs>
    <linearGradient id="grad" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="$($c.Color1)"/>
      <stop offset="1" stop-color="$($c.Color2)"/>
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="18" stdDeviation="18" flood-color="#173a73" flood-opacity="0.18"/>
    </filter>
  </defs>
  <rect x="32" y="32" width="656" height="496" rx="46" fill="#ffffff" stroke="#dbe7f4" stroke-width="4" filter="url(#shadow)"/>
  <circle cx="360" cy="238" r="166" fill="url(#grad)"/>
  <circle cx="360" cy="238" r="132" fill="none" stroke="#ffffff" stroke-width="14" opacity="0.2"/>
  <g transform="translate(88 -10)">
$icon
  </g>
  <text x="360" y="456" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="38" font-weight="800" fill="#173a73">$($c.Title)</text>
  <text x="360" y="500" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="24" font-weight="500" fill="#5f7189">$($c.Subtitle)</text>
</svg>
"@
  Set-Content -LiteralPath (Join-Path $PSScriptRoot "$($c.File).svg") -Value $svg -Encoding UTF8
}
