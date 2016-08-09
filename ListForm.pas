unit ListForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ListView.Types, FMX.ListView, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, FireDAC.FMXUI.Wait, FireDAC.Comp.UI;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDQueryCreateTable: TFDQuery;
    ToolBar1: TToolBar;
    btnAdd: TButton;
    btnDelete: TButton;
    Label1: TLabel;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    FDQuery1: TFDQuery;
    LinkFillControlToFieldShopItem: TLinkFillControlToField;
    BindingsList1: TBindingsList;
    qryInsert: TFDQuery;
    qryDelete: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
  private
    { Private declarations }
procedure OnInputQuery_Close(const AResult: TModalResult; const AValues: array of string);  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
uses  System.IOUtils;

procedure TForm1.btnAddClick(Sender: TObject);
begin
  InputQuery('Enter New Item', ['Name'], [''], Self.OnInputQuery_Close)
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
var
  TaskName: String;
begin
  TaskName := TListViewItem(ListView1.Selected).Text;

  try
    qryDelete.ParamByName('ShopItem').AsString := TaskName;
    qryDelete.ExecSQL();
    FDQuery1.Close;
    FDQuery1.Open;
    btnDelete.Enabled := ListView1.Selected <> nil;
  except
    on e: Exception do
    begin
      SHowMessage(e.Message);
    end;
  end;
end;
procedure TForm1.FDConnection1AfterConnect(Sender: TObject);
begin
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS Item (ShopItem  TEXT NOT NULL)');
    FDQuery1.Close;
    FDQuery1.Open;
end;

procedure TForm1.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FDConnection1.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'shoplist.s3db');
  {$ENDIF}
end;
procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   btnDelete.Enabled := ListView1.Selected <> nil;
end;

procedure TForm1.OnInputQuery_Close(const AResult: TModalResult;
  const AValues: array of string);
var
  TaskName: String;
begin
 TaskName := string.Empty;
  if AResult <> mrOk then
    Exit;
  TaskName := AValues[0];
  try
    if (TaskName.Trim <> '')
    then
    begin
      qryInsert.ParamByName('ShopItem').AsString := TaskName;
      qryInsert.ExecSQL();
      FDQuery1.Close();
      FDQuery1.Open;
      btnDelete.Enabled := ListView1.Selected <> nil;
    end;
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;

end.

//procedure Log(Msg : String);
//begin
//{$IFDEF FPC}
//NSLog(NSSTR(PChar(Msg)));
//{$ENDIF}
//end;
//
//{$IFDEF FPC}
//function MyDirectory : NSString;
//var
//paths : NSArray;
//fileName : NSString;
//begin
//paths := NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, True);
//fileName := paths.objectAtIndex(0);
//Result := fileName;
//end;
//{$ENDIF}
//
//procedure TForm1.Button1Click(Sender: TObject);
//{$IFDEF FPC}
//var
//FileName, SQL : String;
//DB : TSQLite;
//SL : Classes.TStringList;
//{$ENDIF}
//begin
//{$IFDEF FPC}
//FileName := String(MyDirectory.UTF8String)+'/MyDB.sqlite';
//Log(FileName);
//
//DB := TSQLite.Create(FileName);
//
//(*
//// Drop the table and start from scratch
//SQL := 'drop table Customers';
//DB.Query(SQL,nil);
//*)
//
//// Create the table
//SQL := 'create table Customers (Id integer not null, LastName char(25), FirstName char(25))';
//DB.Query(SQL,nil);
//
//// Insert a couple of records
//SQL := 'insert into Customers values(1, "Ohlsson", "Anders")';
//DB.Query(SQL,nil);
//SQL := 'insert into Customers values(2, "Intersimone", "David")';
//DB.Query(SQL,nil);
//
//// Get the records back and list them in the memo
//SL := Classes.TStringList.Create;
//SQL := 'select * from Customers';
//if DB.Query(SQL,SL) then
//Memo1.Text := SL.Text;
//SL.Free;
//
//DB.Free;
//{$ENDIF}
//end;
//

