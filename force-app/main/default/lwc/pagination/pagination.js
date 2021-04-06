import { LightningElement, wire, track, api} from 'lwc';

export default class Pagination extends LightningElement {
    @track currentpage=1;
    @track totalRecords
    @track recordSize=5
    @track totalpage=0
    @track VisibleRecords;
    get records(){
        return this.VisibleRecords
    }
    @api 
    set records(data){
       if(data){
        console.log("pagination1"+data);
            this.totalRecords=data;
            this.totalpage=Math.ceil(data.length/this.recordSize);
            this.updateRecords();
       }
    }
    @api RefreshRecord(data){
        if(data){
            console.log("pagination"+data.length);
             this.totalRecords=data;
             this.totalpage=Math.ceil(data.length/this.recordSize);
             this.updateRecords();
        }
           
    }
    previousHandler(){
        if(this.currentpage > 1){
            this.currentpage-=1;
            this.updateRecords();
        }
    }
    nextHandler(){
        if(this.currentpage < this.totalpage){
            this.currentpage+=1;
            this.updateRecords();
        }
    }
    get disableprevious(){
            return this.currentpage<=1
    }
    get disablenext(){
            return this.currentpage>=this.totalpage
    }
    updateRecords(){
        const start=(this.currentpage-1)*this.recordSize
        const end =this.recordSize*this.currentpage
        this.VisibleRecords=this.totalRecords.slice(start,end);
        this.dispatchEvent(new CustomEvent('update',{
            detail:{
                records:this.VisibleRecords
            }
        }))
    }
}