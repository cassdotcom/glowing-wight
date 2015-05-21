#Required to load the XAML form and create the PowerShell Variables

#.\loadDialog.ps1 -XamlPath 'C:\Users\cass\Documents\Visual Studio 2013\Projects\pshell_gui\forms\CBMForm.xaml'
.\loadDialog.ps1 -XamlPath 'C:\Users\cass\Documents\Visual Studio 2013\Projects\pshell_gui\forms\titleForm.xml'

#EVENT Handler

$bt_CBM.add_Click({

 $logo_TITLE.Content = "Hello World"

})


#Launch the window

$xamGUI.ShowDialog() | out-null