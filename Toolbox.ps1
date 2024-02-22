Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Funktsioon rakenduste avamiseks
function Ava-Rakendus {
    param (
        [string]$rakenduseNimi,
        [string]$rakenduseTee
    )
    Start-Process $rakenduseTee -NoNewWindow
}

# Funktsioon arvuti spetsifikatsioonide hankimiseks
function Hanki-ArvutiSpetsifikatsioonid {
    $spetsifikatsioonid = @()
    
    # Protsessori info
    $processor = Get-WmiObject Win32_Processor
    $spetsifikatsioonid += "Protsessor: $($processor.Name)"

    # Mälu info
    $memory = Get-WmiObject Win32_PhysicalMemory
    $totalMemoryGB = [math]::Round(($memory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
    $spetsifikatsioonid += "Mälu: ${totalMemoryGB}GB"

    # Operatsioonisüsteemi info
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $spetsifikatsioonid += "Operatsioonisüsteem: $($os.Caption) $($os.OSArchitecture), Versioon: $($os.Version)"

    return $spetsifikatsioonid -join "`n"
}

# Funktsioon võrguühenduse teabe hankimiseks
function Hanki-VorguUhendus {
    $networkInfo = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $ipAddress = $networkInfo.IPAddress[0]
    $subnetMask = $networkInfo.IPSubnet
    $defaultGateway = $networkInfo.DefaultIPGateway
    $dnsServers = $networkInfo.DNSServerSearchOrder
    $macAddress = $networkInfo.MACAddress

    $vorguInfo = @"
IP Aadress: $ipAddress
Alamvõrgu Mask: $subnetMask
Vaikimisi Värav: $defaultGateway
DNS Serverid: $($dnsServers -join ', ')
MAC Aadress: $macAddress
"@

    return $vorguInfo
}

# Loo põhivorm
$vorm = New-Object System.Windows.Forms.Form
$vorm.Text = "Toolbox"
$vorm.Size = New-Object System.Drawing.Size(400, 370)
$vorm.StartPosition = "CenterScreen"
$vorm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

# Loo nupud erinevate funktsioonide jaoks
$nuppAnyDesk = New-Object System.Windows.Forms.Button
$nuppAnyDesk.Text = "Ava AnyDesk veebis"
$nuppAnyDesk.Location = New-Object System.Drawing.Point(50, 20)
$nuppAnyDesk.Size = New-Object System.Drawing.Size(200, 40)
$nuppAnyDesk.Add_Click({
    # Lisage siia AnyDesk veebirakenduse avamise käsud
    # Näiteks:
    Start-Process "https://anydesk.com/remote-desktop"
})

$nuppArvutiSpetsifikatsioonid = New-Object System.Windows.Forms.Button
$nuppArvutiSpetsifikatsioonid.Text = "Kuva arvuti spetsifikatsioonid"
$nuppArvutiSpetsifikatsioonid.Location = New-Object System.Drawing.Point(50, 80)
$nuppArvutiSpetsifikatsioonid.Size = New-Object System.Drawing.Size(200, 40)
$nuppArvutiSpetsifikatsioonid.Add_Click({
    $spetsifikatsioonid = Hanki-ArvutiSpetsifikatsioonid
    [System.Windows.Forms.MessageBox]::Show($spetsifikatsioonid, "Arvuti spetsifikatsioonid")
})

$nuppKontrollpaneel = New-Object System.Windows.Forms.Button
$nuppKontrollpaneel.Text = "Ava Kontrollpaneel"
$nuppKontrollpaneel.Location = New-Object System.Drawing.Point(50, 140)
$nuppKontrollpaneel.Size = New-Object System.Drawing.Size(200, 40)
$nuppKontrollpaneel.Add_Click({
    Ava-Rakendus -rakenduseNimi "Kontrollpaneel" -rakenduseTee "control.exe"
})

$nuppVorguUhendus = New-Object System.Windows.Forms.Button
$nuppVorguUhendus.Text = "Kuva võrguühenduse teave"
$nuppVorguUhendus.Location = New-Object System.Drawing.Point(50, 200)
$nuppVorguUhendus.Size = New-Object System.Drawing.Size(200, 40)
$nuppVorguUhendus.Add_Click({
    $vorguInfo = Hanki-VorguUhendus
    [System.Windows.Forms.MessageBox]::Show($vorguInfo, "Võrguühenduse teave")
})

$nuppWindowsUpdate = New-Object System.Windows.Forms.Button
$nuppWindowsUpdate.Text = "Uuenda Windows"
$nuppWindowsUpdate.Location = New-Object System.Drawing.Point(50, 260)
$nuppWindowsUpdate.Size = New-Object System.Drawing.Size(200, 40)
$nuppWindowsUpdate.Add_Click({
    # Lisage siia Windowsi uuendamise käsud
    # Näiteks:
    # Install-WindowsUpdate -AcceptAll
})

# Lisa elemendid vormile
$vorm.Controls.Add($nuppAnyDesk)
$vorm.Controls.Add($nuppArvutiSpetsifikatsioonid)
$vorm.Controls.Add($nuppKontrollpaneel)
$vorm.Controls.Add($nuppVorguUhendus)
$vorm.Controls.Add($nuppWindowsUpdate)

# Käivita vorm
[void]$vorm.ShowDialog()
