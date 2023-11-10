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
$vorm.Text = "Toolkit"
$vorm.Size = New-Object System.Drawing.Size(450, 350)
$vorm.StartPosition = "CenterScreen"
$vorm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

# Loo nupud erinevate rakenduste jaoks
$nuppKontrollpaneel = New-Object System.Windows.Forms.Button
$nuppKontrollpaneel.Text = "Ava Kontrollpaneel"
$nuppKontrollpaneel.Location = New-Object System.Drawing.Point(50, 20)
$nuppKontrollpaneel.Size = New-Object System.Drawing.Size(350, 40)
$nuppKontrollpaneel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$nuppKontrollpaneel.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$nuppKontrollpaneel.ForeColor = [System.Drawing.Color]::White
$nuppKontrollpaneel.Add_Click({
    Ava-Rakendus -rakenduseNimi "Kontrollpaneel" -rakenduseTee "control.exe"
})

$nuppFailiHaldur = New-Object System.Windows.Forms.Button
$nuppFailiHaldur.Text = "Ava Faili Haldur"
$nuppFailiHaldur.Location = New-Object System.Drawing.Point(50, 70)
$nuppFailiHaldur.Size = New-Object System.Drawing.Size(350, 40)
$nuppFailiHaldur.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$nuppFailiHaldur.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$nuppFailiHaldur.ForeColor = [System.Drawing.Color]::White
$nuppFailiHaldur.Add_Click({
    Ava-Rakendus -rakenduseNimi "Faili Haldur" -rakenduseTee "explorer.exe"
})

$nuppTegumihaldur = New-Object System.Windows.Forms.Button
$nuppTegumihaldur.Text = "Ava Tegumihaldur"
$nuppTegumihaldur.Location = New-Object System.Drawing.Point(50, 120)
$nuppTegumihaldur.Size = New-Object System.Drawing.Size(350, 40)
$nuppTegumihaldur.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$nuppTegumihaldur.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$nuppTegumihaldur.ForeColor = [System.Drawing.Color]::White
$nuppTegumihaldur.Add_Click({
    Ava-Rakendus -rakenduseNimi "Tegumihaldur" -rakenduseTee "taskmgr.exe"
})

$nuppSpetsifikatsioonid = New-Object System.Windows.Forms.Button
$nuppSpetsifikatsioonid.Text = "Kuva arvuti spetsifikatsioonid"
$nuppSpetsifikatsioonid.Location = New-Object System.Drawing.Point(50, 170)
$nuppSpetsifikatsioonid.Size = New-Object System.Drawing.Size(350, 40)
$nuppSpetsifikatsioonid.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$nuppSpetsifikatsioonid.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$nuppSpetsifikatsioonid.ForeColor = [System.Drawing.Color]::White
$nuppSpetsifikatsioonid.Add_Click({
    $spetsifikatsioonid = Hanki-ArvutiSpetsifikatsioonid
    [System.Windows.Forms.MessageBox]::Show($spetsifikatsioonid, "Arvuti spetsifikatsioonid")
})

$nuppVorguUhendus = New-Object System.Windows.Forms.Button
$nuppVorguUhendus.Text = "Kuva võrguühenduse teave"
$nuppVorguUhendus.Location = New-Object System.Drawing.Point(50, 220)
$nuppVorguUhendus.Size = New-Object System.Drawing.Size(350, 40)
$nuppVorguUhendus.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$nuppVorguUhendus.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$nuppVorguUhendus.ForeColor = [System.Drawing.Color]::White
$nuppVorguUhendus.Add_Click({
    $vorguInfo = Hanki-VorguUhendus
    [System.Windows.Forms.MessageBox]::Show($vorguInfo, "Võrguühenduse teave")
})

# Loo nupp rakenduse sulgemiseks
$nuppLopeta = New-Object System.Windows.Forms.Button
$nuppLopeta.Text = "Lõpeta"
$nuppLopeta.Location = New-Object System.Drawing.Point(50, 270)
$nuppLopeta.Size = New-Object System.Drawing.Size(350, 40)
$nuppLopeta.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$nuppLopeta.BackColor = [System.Drawing.Color]::FromArgb(215, 0, 0)
$nuppLopeta.ForeColor = [System.Drawing.Color]::White
$nuppLopeta.Add_Click({
    $vorm.Close()
})

# Lisa elemendid vormile
$vorm.Controls.Add($nuppKontrollpaneel)
$vorm.Controls.Add($nuppFailiHaldur)
$vorm.Controls.Add($nuppTegumihaldur)
$vorm.Controls.Add($nuppSpetsifikatsioonid)
$vorm.Controls.Add($nuppVorguUhendus)
$vorm.Controls.Add($nuppLopeta)

# Käivita vorm
[void]$vorm.ShowDialog()
