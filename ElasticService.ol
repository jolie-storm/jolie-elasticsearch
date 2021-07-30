from .ElasticInterface import ElasticInterface
from string_utils import StringUtils
from console import Console

interface ElasticInternalInterface{
    RequestResponse:
        create(undefined)(undefined),
        insert(undefined)(undefined),
        insertWithId(undefined)(undefined),
        get(undefined)(undefined),
        del(void)(undefined),
        createIndex(undefined)(undefined),
        deleteIndex(undefined)(undefined)
}

service ElasticService{

  embed StringUtils as stringUtils  
  embed Console as console  

  inputPort ip {
      Location: "local" 
      Interfaces: ElasticInterface
  }

  outputPort clusterPort{
      Location: "local"
      Interfaces: ElasticInternalInterface
      protocol:"http" {
          .keepAlive = false;
          .debug = true;
          .debug.showContent = true;
          .compression = false;
          .format -> format;
          .method -> method;
      }
  }


  execution{ concurrent }
  
  main{
    [setClusterLocation(request)(response){
        global.url = request.url
    }]

    [insertDocument(request)(response){

        
        format = "json"
        clusterPort.location = global.url
        if (is_defined(request.id)){
            foreach ( payloadElement : request.payload ) {
                  requestElastic.(payloadElement) = request.payload.(payloadElement)
            }
            if (request.unique == true){
               method = "POST" 
               clusterPort.protocol.osc.create.alias =   request.index + "/create/" + request.id
               create@clusterPort(requestElastic)(responseElastic)
            }else{
               method = "POST" 
               clusterPort.protocol.osc.insertWithId.alias =   request.index + "/_doc/" + request.id
               insertWithId@clusterPort(requestElastic)(responseElastic)
            }
        }else{
            clusterPort.protocol.osc.insert.alias =  request.index + "/_doc"
            foreach ( payloadElement : request.payload ) {
                  requestElastic.(payloadElement) = request.payload.(payloadElement)
            }
            method = "POST" 
            insert@clusterPort(requestElastic)(responseElastic)
        }


        if (is_defined (responseElastic.status)){
                if (responseElastic.error instanceof string){
                    throw (ElasticError , responseElastic.error)
                }

                if (responseElastic.error.reason instanceof string){
                    throw (ElasticError , responseElastic.error.reason)
                }
        }

        response.shards << responseElastic._shards
        response.index = responseElastic._index
        response.type = responseElastic._type
        response.id = responseElastic._id
        response.version = responseElastic._version
        response.seqNo = responseElastic._seq_no
        response.primaryTerm = responseElastic._primary_term
        response.result = responseElastic.result


    }]

    [getDocument(request)(response){
        clusterPort.protocol.osc.get.alias =  request.index + "/_doc/" + request.id
        clusterPort.location = global.url
        method = "GET"
        get@clusterPort(  )( responseElastic )
        if (is_defined (responseElastic.status)){
                if (responseElastic.error instanceof string){
                    throw (ElasticError , responseElastic.error)
                }

                if (responseElastic.error.reason instanceof string){
                    throw (ElasticError , responseElastic.error.reason)
                }
        }
        if (responseElastic.found){
                
                    response.payload << responseElastic._source
                    response.version = responseElastic._version
        }
        response.found = responseElastic.found
    
    }]



    [deleteDocument(request)(response){
        //format = "json"
        clusterPort.protocol.osc.del.alias =  request.index + "/_doc/" + request.id
        clusterPort.location = global.url
        method = "DELETE"
        del@clusterPort(  )( responseElastic )
        if (is_defined (responseElastic.status)){
                if (responseElastic.error instanceof string){
                    throw (ElasticError , responseElastic.error)
                }

                if (responseElastic.error.reason instanceof string){
                    throw (ElasticError , responseElastic.error.reason)
                }
        }


        response.shards << responseElastic._shards
        response.index = responseElastic._index
        response.type = responseElastic._type
        response.id = responseElastic._id
        response.version = responseElastic._version
        response.seqNo = responseElastic._seq_no
        response.primaryTerm = responseElastic._primary_term
        response.result = responseElastic.result
    
    }]

    [createIndex(request)(response){
            format = "json"
            method = "PUT" 
            clusterPort.location = global.url
            clusterPort.protocol.osc.createIndex.alias =  request.index 
            createIndex@clusterPort( )( responseElastic )
            if (is_defined (responseElastic.status)){
                if (responseElastic.error instanceof string){
                    throw (ElasticError , responseElastic.error)
                }

                if (responseElastic.error.reason instanceof string){
                    throw (ElasticError , responseElastic.error.reason)
                }
            }
    }]
  }

}