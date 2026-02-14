let
    // Accessed the insurance payer master list from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the healthcare insurance providers file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="insurance.csv"]}[Content],

    // Imported the CSV document with a 2-column schema (ID and Provider Name).
    Imported_Insurance_Data = Csv.Document(File_Content,[Delimiter=",", Columns=2, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify payer codes and company names.
    Promote_Headers = Table.PromoteHeaders(Imported_Insurance_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to ensure a clean join with the Visits fact table.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Insurance ID", Int64.Type}, 
        {"Insurance Provider", type text}
    }),

    // Renamed headers to follow a standardized naming convention for financial reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"Insurance Provider", "Payer Name"}
    })
in
    Renamed_Columns
