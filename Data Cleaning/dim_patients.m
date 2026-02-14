let
    // Accessed the patient master records from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Targeted the specific binary content for the patient demographics file.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="patients.csv"]}[Content],

    // Imported the CSV document with the 6-column demographic schema.
    Imported_Patient_Data = Csv.Document(File_Content,[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify patient IDs, names, and regional links.
    Promote_Headers = Table.PromoteHeaders(Imported_Patient_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types to support age-slicing and equity-based reporting (Race/Gender).
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Patient ID", Int64.Type}, 
        {"Patient Name", type text}, 
        {"Gender", type text}, 
        {"Age", Int64.Type}, 
        {"City ID", Int64.Type}, 
        {"Race", type text}
    }),

    // Renamed headers to maintain a professional and consistent convention across the model.
    Renamed_Columns = Table.RenameColumns(Set_Data_Types,{
        {"Age", "Patient Age"},
        {"Race", "Ethnicity/Race"}
    })
in
    Renamed_Columns
