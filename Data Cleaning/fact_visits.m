let
    // Extracted patient visit and clinical records from the local directory.
    Source_Folder = Folder.Files("your_folder_path"),

    // Accessed the specific binary content for the healthcare visits dataset.
    File_Content = Source_Folder{[#"Folder Path"="your_folder_path\",Name="visits.csv"]}[Content],

    // Imported the CSV document with the 20-column clinical and financial schema.
    Imported_Visits_Data = Csv.Document(File_Content,[Delimiter=",", Columns=20, Encoding=1252, QuoteStyle=QuoteStyle.None]),

    // Promoted the first row to headers to identify patient, provider, and cost metrics.
    Promote_Headers = Table.PromoteHeaders(Imported_Visits_Data, [PromoteAllScalars=true]),

    // Assigned standardized data types in a single step to support length-of-stay and financial analysis.
    Set_Data_Types = Table.TransformColumnTypes(Promote_Headers,{
        {"Date of Visit", type date}, {"Patient ID", Int64.Type}, {"Provider ID", Int64.Type}, 
        {"Department ID", Int64.Type}, {"Diagnosis ID", Int64.Type}, {"Procedure ID", Int64.Type}, 
        {"Insurance ID", Int64.Type}, {"Service Type", type text}, {"Treatment Cost", Int64.Type}, 
        {"Medication Cost", Int64.Type}, {"Follow-Up Visit Date", type date}, 
        {"Patient Satisfaction Score", Int64.Type}, {"Referral Source", type text}, 
        {"Emergency Visit", type text}, {"Payment Status", type text}, {"Discharge Date", type date}, 
        {"Admitted Date", type date}, {"Room Type", type text}, {"Insurance Coverage", type number}, 
        {"Room Charges(daily rate)", Int64.Type}
    }),

    // Standardized the 'Referral Source' values to remove typos and simplify categorical grouping.
    Clean_Referral_Sources = Table.TransformColumns(Set_Data_Types, {
        {"Referral Source", each if _ = "Self-Referrral" or _ = "Self-Referral" then "Self" 
            else if _ = "Physician Referral" then "Physician" 
            else _, type text}
    }),

    // Renamed headers to follow professional healthcare administration and BI standards.
    Renamed_Final_Columns = Table.RenameColumns(Clean_Referral_Sources,{
        {"Date of Visit", "Visit Date"},
        {"Follow-Up Visit Date", "Follow-Up Date"},
        {"Patient Satisfaction Score", "Satisfaction Score"},
        {"Emergency Visit", "Visit Type (ER/Regular)"},
        {"Room Charges(daily rate)", "Daily Room Rate"},
        {"Insurance Coverage", "Insurance Coverage %"}
    })
in
    Renamed_Final_Columns
