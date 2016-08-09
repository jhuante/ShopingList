program ShopingList;

uses
  System.StartUpCopy,
  FMX.Forms,
  ListForm in 'ListForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
