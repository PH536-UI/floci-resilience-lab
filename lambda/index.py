import boto3, json, os, socket, traceback

def handler(event, context):
    ep = os.environ.get('AWS_ENDPOINT_URL') or f"http://{os.environ.get('LOCALSTACK_HOSTNAME', 'host.docker.internal')}:4566"
    print(f"DEBUG endpoint={ep}")
    print(f"DEBUG LOCALSTACK_HOSTNAME={os.environ.get('LOCALSTACK_HOSTNAME')}")

    try:
        host = ep.split('//')[1].split(':')[0]
        ip = socket.gethostbyname(host)
        print(f"DEBUG DNS resolveu {host} -> {ip}")
    except Exception as e:
        print(f"DEBUG DNS FALHOU: {e}")

    try:
        dynamodb = boto3.resource('dynamodb', endpoint_url=ep, region_name='sa-east-1', aws_access_key_id='test', aws_secret_access_key='test')
        table = dynamodb.Table(os.environ['TABLE_NAME'])
        for r in event.get('Records', []):
            body = json.loads(r['body'])
            print(f"Processando: {body}")
            table.put_item(Item={'id': body.get('id'), 'message': body.get('message')})
        return {'statusCode': 200, 'processed': len(event.get('Records', []))}
    except Exception as e:
        print(f"DEBUG ERRO: {e}")
        print(traceback.format_exc())
        raise e
