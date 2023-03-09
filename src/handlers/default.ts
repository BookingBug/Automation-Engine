import { APIGatewayEvent, Handler } from 'aws-lambda';


export const livecheck: Handler = async (event: APIGatewayEvent) => {
        console.log(event)
        try {
            return Promise.resolve({
                status: 'ok',
            });
        } catch (err) {
            return err;
        }
};
