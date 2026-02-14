let
    // Accessed the procedure master list from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the healthcare procedures file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="procedures.csv"]}[Content],

    // Imported the CSV document with a 2-column schema (ID and Description).
    Imported_Procedure_Data = Csv.Document(File_Content,[Delimiter=",", Columns=2, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify procedure codes and names.
    Promote_Headers = Table.PromoteHeaders(Imported_Procedure_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support high-performance joining with the Visits table.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Procedure ID", Int64.Type}, 
        {"Procedure", type text}
    }),

    // Renamed headers to follow a professional, descriptive naming convention.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"Procedure", "Procedure Description"}
    })
in
    Renamed_Columns
