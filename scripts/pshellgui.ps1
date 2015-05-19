#Required to load the XAML form and create the PowerShell Variables

.\loadDialog.ps1 -XamlPath 'C:\Users\cass\Documents\Visual Studio 2013\Projects\pshell_gui\forms\CBMForm.xaml'


#EVENT Handler

$button1.add_Click({

 $Label1.Content = "Hello World"

})


#Launch the window

$xamGUI.ShowDialog() | out-null