type InsertDocumentRequest{
   .index:string
   .unique?:bool
   .id?:string
   .payload:undefined 
}


type PositiveDocumentResponse{
    shards{
        total: int
        successful:int
        failed*:int
    }
    index :string
    type: string 
    id:string
    version:int
    seqNo:int
    primaryTerm:int
    result: string
} 


type SetClusterLocationRequest{
  url:string
}


type SetClusterLocationResponse:void


type InsertDocumentResponse : PositiveDocumentResponse

type CreateIndexRequest{
    index:string
}

type CreateIndexResponse:void



type DeleteIndexRequest{
    index:string
}

type DeleteIndexResponse:void

type GetDocumentRequest{
    index:string
    id:string
}

type GetDocumentResponse{
    found:bool
    version?:int
    payload?:undefined
}


type DeleteDocumentRequest{
    index:string
    id:string
}


type DeleteDocumentResponse{
    shards{
        total: int
        successful:int
        failed*:int
    }
    index :string
    type: string 
    id:string
    version:int
    seqNo:int
    primaryTerm:int
    result: string
}

interface ElasticInterface{
    RequestResponse:
     setClusterLocation(SetClusterLocationRequest)(SetClusterLocationResponse),
     insertDocument(InsertDocumentRequest)(InsertDocumentResponse) throws ElasticError(string),
     getDocument(GetDocumentRequest)(GetDocumentResponse) throws ElasticError(string),
     deleteDocument(DeleteDocumentRequest)(DeleteDocumentResponse) throws ElasticError(string),
     createIndex(CreateIndexRequest)(CreateIndexResponse) throws ElasticError(string),
     deleteIndex(DeleteIndexRequest)(DeleteIndexResponse) throws ElasticError(string)
} 
