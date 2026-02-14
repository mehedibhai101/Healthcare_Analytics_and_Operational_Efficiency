let
    // Accessed the diagnosis master list from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the healthcare diagnoses file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="diagnose.csv"]}[Content],

    // Imported the CSV document with a 2-column schema (ID and Clinical Condition).
    Imported_Diagnosis_Data = Csv.Document(File_Content,[Delimiter=",", Columns=2, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify diagnosis codes and names.
    Promote_Headers = Table.PromoteHeaders(Imported_Diagnosis_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support high-performance joining with the Visits table.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Diagnosis ID", Int64.Type}, 
        {"Diagnosis", type text}
    }),

    // Renamed headers to follow a professional, descriptive naming convention for clinical reporting.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"Diagnosis", "Diagnosis Name"}
    })
in
    Renamed_Columns
