defmodule Pastry.PastryNode do
    use GenServer

    #Genserver DEF functions    
    def start_link(nodeID) do
        GenServer.start_link(__MODULE__,%{nodeID: nodeID},name: String.to_atom(nodeID))
    end

    def init(init_data) do
        {:ok,init_data} 
    end

    #Debugging the nodes ############################################################################################################
    defp getSmallerLeafSet(nodeID) do
        GenServer.call(nodeID,:getSmallerLeafSet)      
    end

    defp getLargerLeafSet(nodeID) do
        GenServer.call(nodeID,:getLargerLeafSet)
    end

    def printNodes(nodeID) do
        if (is_nil(nodeID)) do
        else
          printNodes (getSmallerLeafSet(String.to_atom(nodeID)))
          IO.puts nodeID
          printNodes (getLargerLeafSet(String.to_atom(nodeID)))
        end        
    end
    ##############################################################################################################################

    #implementing the pastry API

    #pastryInit pastryInit(Credentials, Application):
    #causes the local node to join an existing Pastry 
    #network (or start a new one), initialize all relevant state, and return the local node’s nodeId. 
    #The application-specific credentials contain information needed to authenticate the local node. 
    #The application argument is a handle to the application object that provides the Pastry node with 
    #the procedures to invoke whencertain events happen, e.g., a message arrival.
    def pastryInit(credentials, application) do
        start_link(credentials)
    end  

    #populating leaf set
    def newLeaves(pid, smallerLeafset, largerLeafSet) do
        GenServer.cast(String.to_atom(pid), {:newLeaves, smallerLeafset,largerLeafSet})
        #GenServer.cast()
    end 

    #deliver(msg,key):
    # called by Pastry when a message is received and the local node’s nodeId is numerically closest to key, among all live nodes.
    def deliver(msg, key) do
        IO.puts("Total number of hops required for delivery :"<>Integer.to_string(Map.get(msg,:hops)))
        IO.puts("Message string :"<>Map.get(msg,:msg))
    end

    #route(msg,key):
    # causes Pastry to route the given message to the node with nodeId numerically closest to the key, among all live Pastry nodes.
    def route(msg, key,nodeID) do
        msgPacket = %{msg: msg, hops: 0}
        nextID=nodeID
        forward(msgPacket,key,nextID)
    end

    #forward(msg,key,nextId):
    #Called by Pastry just before a message is forwarded to the  node  with nodeId = nextId. 
    #The application may change the contents of the message or the value of nextId. 
    #Setting the nextId to NULL terminates the message at the local node.
    def forward(msg, key, nodeID)do
        :timer.sleep(1000)
        msg=Map.put(msg,:hops,Map.get(msg,:hops) +1)
        cond do
            (is_nil(nodeID) or nodeID==key) -> deliver(msg,key)
            key>nodeID -> forward(msg,key,(getLargerLeafSet(String.to_atom(nodeID))))
            key<nodeID -> forward(msg,key,(getSmallerLeafSet(String.to_atom(nodeID))))
        end
    end

    ##################################################################################################################################    
    
    #server side functions
    
    #Populating the leaf set
    def handle_cast({:newLeaves,smallerLeafset,largerLeafSet }, state) do
        state=Map.put(state,:smallerLeafset,smallerLeafset)
        state=Map.put(state,:largerLeafSet,largerLeafSet)
        {:noreply, state}
    end

    def handle_call(:getLargerLeafSet,_from,state) do
        {:reply, Map.get(state,:largerLeafSet),state}
    end

    def handle_call(:getSmallerLeafSet,_from,state) do
        {:reply, Map.get(state,:smallerLeafset),state}
    end


end