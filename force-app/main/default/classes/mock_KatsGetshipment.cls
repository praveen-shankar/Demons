public class mock_KatsGetshipment {
	
	private static final postenNoEconnectKatsGetshipment.KATS_GetShipmentOutParametersType shipment;

	static {
		shipment = new postenNoEconnectKatsGetshipment.KATS_GetShipmentOutParametersType();
		
		shipment.ShipmentUnit = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
		
		shipment.ShipmentUnit.ShipmentUnitID = '000000000000000000';
		shipment.ShipmentUnit.RelabledShipmentUnitID = '111111111111111111';
		shipment.ShipmentUnit.ShipmentID = '222222222222222222';
		shipment.ShipmentUnit.ShipmentSequence = '333333333333333333';
		shipment.ShipmentUnit.SpecialFreight =
		shipment.ShipmentUnit.ProductName = 'test product';
		shipment.ShipmentUnit.ProductCode = '9999';
		shipment.ShipmentUnit.NewProductCode = '8888';
		shipment.ShipmentUnit.NewProductName = 'new test product';
		shipment.ShipmentUnit.SenderReference = 'sender';
		shipment.ShipmentUnit.RecipientReference = 'reciever';
		shipment.ShipmentUnit.DelieverySignature = 'signature';
		shipment.ShipmentUnit.ShipmentDateTime = datetime.newInstance(2000, 1, 1, 12, 0, 0);
		
		shipment.ShipmentUnit.PostingTerminal
			= new postenNoEconnectKatsGetshipment.AddressTerminalType();
			shipment.ShipmentUnit.PostingTerminal.Street = 'Terminal Street';
			shipment.ShipmentUnit.PostingTerminal.PostalCode  = '0000';
			shipment.ShipmentUnit.PostingTerminal.City = 'Terminal City';
			shipment.ShipmentUnit.PostingTerminal.MunicipalityName = 'Terminal Municipality';
			shipment.ShipmentUnit.PostingTerminal.MunicipalityCode = '9999';
			shipment.ShipmentUnit.PostingTerminal.Country = 'Norway';
			shipment.ShipmentUnit.PostingTerminal.CountryCode = '47';
			shipment.ShipmentUnit.PostingTerminal.type_x = 'Terminal type';
			shipment.ShipmentUnit.PostingTerminal.UnitNumber = '0000';
			shipment.ShipmentUnit.PostingTerminal.UnitName = 'Test unit';
			
		shipment.ShipmentUnit.CurrentCity
			= new postenNoEconnectKatsGetshipment.AddressType();
			shipment.ShipmentUnit.CurrentCity.Street = 'Current city Street';
			shipment.ShipmentUnit.CurrentCity.PostalCode  = '0000';
			shipment.ShipmentUnit.CurrentCity.City = 'Current city City';
			shipment.ShipmentUnit.CurrentCity.MunicipalityName = 'Current city Municipality';
			shipment.ShipmentUnit.CurrentCity.MunicipalityCode = '9999';
			shipment.ShipmentUnit.CurrentCity.Country = 'Norway';
			shipment.ShipmentUnit.CurrentCity.CountryCode = '47';
			shipment.ShipmentUnit.CurrentCity.type_x = 'Current city type';
			
		shipment.ShipmentUnit.ShipToAddress
			= new postenNoEconnectKatsGetshipment.AddressType();
			shipment.ShipmentUnit.ShipToAddress.Street = 'Ship to Street';
			shipment.ShipmentUnit.ShipToAddress.PostalCode  = '0000';
			shipment.ShipmentUnit.ShipToAddress.City = 'Ship to City';
			shipment.ShipmentUnit.ShipToAddress.MunicipalityName = 'Ship to Municipality';
			shipment.ShipmentUnit.ShipToAddress.MunicipalityCode = '9999';
			shipment.ShipmentUnit.ShipToAddress.Country = 'Norway';
			shipment.ShipmentUnit.ShipToAddress.CountryCode = '47';
			shipment.ShipmentUnit.ShipToAddress.type_x = 'Ship to type';
			
		shipment.ShipmentUnit.Insurance
			= new postenNoEconnectKatsGetshipment.InsuranceType();
			shipment.ShipmentUnit.Insurance.DeclaredValueAmount = '100';
			shipment.ShipmentUnit.Insurance.Description = 'Insurance description';
			
		shipment.ShipmentUnit.ShipmentDescription
			= new postenNoEconnectKatsGetshipment.ShipmentDescription();
			shipment.ShipmentUnit.ShipmentDescription.Description = 'ShipmentUnit description';
			shipment.ShipmentUnit.ShipmentDescription.WeightMeasure = '100';
			shipment.ShipmentUnit.ShipmentDescription.HeightMeasure = '10';
			shipment.ShipmentUnit.ShipmentDescription.LengthMeasure = '10';
			shipment.ShipmentUnit.ShipmentDescription.WidthMeasure = '10';
			
		shipment.ShipmentUnit.ValueAddedServices = new postenNoEconnectKatsGetshipment.ValueAddedServices_element();
		shipment.ShipmentUnit.ValueAddedServices.ValueAddedService
			= new list<postenNoEconnectKatsGetshipment.ValueAddedService>();
			shipment.ShipmentUnit.ValueAddedServices.ValueAddedService.add(new postenNoEconnectKatsGetshipment.ValueAddedService());
			
			shipment.ShipmentUnit.ValueAddedServices.ValueAddedService.get(0).Status = 'Test status';
			shipment.ShipmentUnit.ValueAddedServices.ValueAddedService.get(0).ServiceName = 'Test Service Name';
			shipment.ShipmentUnit.ValueAddedServices.ValueAddedService.get(0).CoDAmount = '100';
			shipment.ShipmentUnit.ValueAddedServices.ValueAddedService.get(0).BankAccountNumber = '1234567890123';
		
		shipment.ShipmentUnit.SortingMachineInfo = new postenNoEconnectKatsGetshipment.SortingMachineInfo_element();
		shipment.ShipmentUnit.SortingMachineInfo.SortingInfo
			= new list<postenNoEconnectKatsGetshipment.SortingInfo_element>();
			shipment.ShipmentUnit.SortingMachineInfo.SortingInfo.add(new postenNoEconnectKatsGetshipment.SortingInfo_element());
			shipment.ShipmentUnit.SortingMachineInfo.SortingInfo.add(new postenNoEconnectKatsGetshipment.SortingInfo_element());
						
			shipment.ShipmentUnit.SortingMachineInfo.SortingInfo.get(0).BoardNumber = '10';
			shipment.ShipmentUnit.SortingMachineInfo.SortingInfo.get(0).Ramp = '10';
			shipment.ShipmentUnit.SortingMachineInfo.SortingInfo.get(0).BoardNumber = '20';
			shipment.ShipmentUnit.SortingMachineInfo.SortingInfo.get(0).Ramp = '20';
		
		shipment.ShipmentUnit.Events = new postenNoEconnectKatsGetshipment.Events_element();
		shipment.ShipmentUnit.Events.Event
			= new list<postenNoEconnectKatsGetshipment.ShipmentEventType>();
			shipment.ShipmentUnit.Events.Event.add(new postenNoEconnectKatsGetshipment.ShipmentEventType());
			shipment.ShipmentUnit.Events.Event.add(new postenNoEconnectKatsGetshipment.ShipmentEventType());
			shipment.ShipmentUnit.Events.Event.add(new postenNoEconnectKatsGetshipment.ShipmentEventType());
			
			shipment.ShipmentUnit.Events.Event.get(0).EventCode = 'Event code';
			shipment.ShipmentUnit.Events.Event.get(0).EventName = 'Event 1';
			shipment.ShipmentUnit.Events.Event.get(0).CaseDescription = 'Case description';
			shipment.ShipmentUnit.Events.Event.get(0).UnitNumber = '0000';
			shipment.ShipmentUnit.Events.Event.get(0).PostalCode = '1234';
			shipment.ShipmentUnit.Events.Event.get(0).UserName = 'User name';
			shipment.ShipmentUnit.Events.Event.get(0).Date_x = datetime.newInstance(2000, 1, 1, 12, 0, 0);
			shipment.ShipmentUnit.Events.Event.get(0).EtterregDate = datetime.newInstance(2001, 1, 1, 12, 0, 0);
			shipment.ShipmentUnit.Events.Event.get(0).CountryCode = '47';
			shipment.ShipmentUnit.Events.Event.get(0).Country = 'Norway';
			shipment.ShipmentUnit.Events.Event.get(0).Cause = 'None';
			shipment.ShipmentUnit.Events.Event.get(0).Action = 'Action';
			shipment.ShipmentUnit.Events.Event.get(0).FreeText = 'This is an event';
			shipment.ShipmentUnit.Events.Event.get(0).ShipmentUnitID = shipment.ShipmentUnit.ShipmentUnitID;
			shipment.ShipmentUnit.Events.Event.get(0).ReceivedBy = 'Test';
			shipment.ShipmentUnit.Events.Event.get(0).Signature = 'Signature';
			shipment.ShipmentUnit.Events.Event.get(0).SendtBy = 'Test user';
			shipment.ShipmentUnit.Events.Event.get(0).ReceiverCity = 'Test City';
			shipment.ShipmentUnit.Events.Event.get(0).StationID = 'Station id 1';
			
			shipment.ShipmentUnit.Events.Event.get(1).EventCode = 'Event code';
			shipment.ShipmentUnit.Events.Event.get(1).EventName = 'Event 2';
			shipment.ShipmentUnit.Events.Event.get(1).CaseDescription = 'Case description';
			shipment.ShipmentUnit.Events.Event.get(1).UnitNumber = '0000';
			shipment.ShipmentUnit.Events.Event.get(1).PostalCode = '1234';
			shipment.ShipmentUnit.Events.Event.get(1).UserName = 'User name';
			shipment.ShipmentUnit.Events.Event.get(1).Date_x = datetime.newInstance(2000, 1, 1, 12, 0, 0);
			shipment.ShipmentUnit.Events.Event.get(1).EtterregDate = datetime.newInstance(2001, 1, 1, 12, 0, 0);
			shipment.ShipmentUnit.Events.Event.get(1).CountryCode = '47';
			shipment.ShipmentUnit.Events.Event.get(1).Country = 'Norway';
			shipment.ShipmentUnit.Events.Event.get(1).Cause = 'None';
			shipment.ShipmentUnit.Events.Event.get(1).Action = 'Action';
			shipment.ShipmentUnit.Events.Event.get(1).FreeText = 'This is an event';
			shipment.ShipmentUnit.Events.Event.get(1).ShipmentUnitID = shipment.shipmentUnit.ShipmentUnitID;
			shipment.ShipmentUnit.Events.Event.get(1).ReceivedBy = 'Test';
			shipment.ShipmentUnit.Events.Event.get(1).Signature = 'Signature';
			shipment.ShipmentUnit.Events.Event.get(1).SendtBy = 'Test user';
			shipment.ShipmentUnit.Events.Event.get(1).ReceiverCity = 'Test City';
			shipment.ShipmentUnit.Events.Event.get(1).StationID = 'Station id 2';
			
			shipment.ShipmentUnit.Events.Event.get(2).EventCode = 'Event code';
			shipment.ShipmentUnit.Events.Event.get(2).EventName = 'Event 3';
			shipment.ShipmentUnit.Events.Event.get(2).CaseDescription = 'Case description';
			shipment.ShipmentUnit.Events.Event.get(2).UnitNumber = '0000';
			shipment.ShipmentUnit.Events.Event.get(2).PostalCode = '1234';
			shipment.ShipmentUnit.Events.Event.get(2).UserName = 'User name';
			shipment.ShipmentUnit.Events.Event.get(2).Date_x = datetime.newInstance(2000, 1, 1, 12, 0, 0);
			shipment.ShipmentUnit.Events.Event.get(2).EtterregDate = datetime.newInstance(2001, 1, 1, 12, 0, 0);
			shipment.ShipmentUnit.Events.Event.get(2).CountryCode = '47';
			shipment.ShipmentUnit.Events.Event.get(2).Country = 'Norway';
			shipment.ShipmentUnit.Events.Event.get(2).Cause = 'None';
			shipment.ShipmentUnit.Events.Event.get(2).Action = 'Action';
			shipment.ShipmentUnit.Events.Event.get(2).FreeText = 'This is an event';
			shipment.ShipmentUnit.Events.Event.get(2).ShipmentUnitID = shipment.ShipmentUnit.ShipmentUnitID;
			shipment.ShipmentUnit.Events.Event.get(2).ReceivedBy = 'Test';
			shipment.ShipmentUnit.Events.Event.get(2).Signature = 'Signature';
			shipment.ShipmentUnit.Events.Event.get(2).SendtBy = 'Test user';
			shipment.ShipmentUnit.Events.Event.get(2).ReceiverCity = 'Test City';
			shipment.ShipmentUnit.Events.Event.get(2).StationID = 'Station id 3';
		
		shipment.ShipmentUnit.Sender
			= new postenNoEconnectKatsGetshipment.ShipmentPartyAddress();
			shipment.ShipmentUnit.Sender.Street = 'Sender street';
			shipment.ShipmentUnit.Sender.PostalCode = '2345';
			shipment.ShipmentUnit.Sender.City = 'Sender City';
			shipment.ShipmentUnit.Sender.MunicipalityName = 'Sender Municipality';
			shipment.ShipmentUnit.Sender.MunicipalityCode = '9999';
			shipment.ShipmentUnit.Sender.Country = 'Norway';
			shipment.ShipmentUnit.Sender.CountryCode = '47';
			shipment.ShipmentUnit.Sender.type_x = 'Type';
			shipment.ShipmentUnit.Sender.PartyNumber = '0000';
			shipment.ShipmentUnit.Sender.FullName = 'Sender Account';
		
		shipment.ShipmentUnit.Recipient
			= new postenNoEconnectKatsGetshipment.ShipmentPartyAddress();
			shipment.ShipmentUnit.Recipient.Street = 'Reciever street';
			shipment.ShipmentUnit.Recipient.PostalCode = '2345';
			shipment.ShipmentUnit.Recipient.City = 'Reciever City';
			shipment.ShipmentUnit.Recipient.MunicipalityName = 'Reciever Municipality';
			shipment.ShipmentUnit.Recipient.MunicipalityCode = '9999';
			shipment.ShipmentUnit.Recipient.Country = 'Norway';
			shipment.ShipmentUnit.Recipient.CountryCode = '47';
			shipment.ShipmentUnit.Recipient.type_x = 'Type';
			shipment.ShipmentUnit.Recipient.PartyNumber = '0000';
			shipment.ShipmentUnit.Recipient.FullName = 'Reciever Account';
	}
	
	public class mock_shipment implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
			
				response.put('response_x', mock_KatsGetshipment.getShipment());
		}
	}
	
	public static postenNoEconnectKatsGetshipment.KATS_GetShipmentOutParametersType getShipment() {
		return shipment;
	}
}